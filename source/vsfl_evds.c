////////////////////////////////////////////////////////////////////////////////
/// @file
///
/// @brief Virtual SpaceFlight Network
////////////////////////////////////////////////////////////////////////////////
/// Copyright (C) 2012-2013, Black Phoenix
///
/// This program is free software; you can redistribute it and/or modify it under
/// the terms of the GNU Lesser General Public License as published by the Free Software
/// Foundation; either version 2 of the License, or (at your option) any later
/// version.
///
/// This program is distributed in the hope that it will be useful, but WITHOUT
/// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
/// FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
/// details.
///
/// You should have received a copy of the GNU Lesser General Public License along with
/// this program; if not, write to the Free Software Foundation, Inc., 59 Temple
/// Place - Suite 330, Boston, MA  02111-1307, USA.
///
/// Further information about the GNU Lesser General Public License can also be found on
/// the world wide web at http://www.gnu.org.
////////////////////////////////////////////////////////////////////////////////
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <windows.h>
#include "vsfl.h"

//Virtual SpaceFlight Network EVDS related information
VSFL_EVDS vsfl = { 0 };


////////////////////////////////////////////////////////////////////////////////
/// @brief Setup empty EVDS state
////////////////////////////////////////////////////////////////////////////////
void VSFL_EVDS_CreateEmptyState() {
	EVDS_OBJECT* inertial_earth;
	EVDS_OBJECT* solar_system;
	EVDS_OBJECT* planet_earth;
	EVDS_OBJECT* planet_earth_moon;
	EVDS_OBJECT* hangar_building;
	EVDS_VECTOR vector;

	//Create solar system inertial space
	EVDS_Object_Create(vsfl.evds_system,0,&solar_system);
	EVDS_Object_SetName(solar_system,"Solar_Inertial_Space");
	EVDS_Object_SetType(solar_system,"propagator_rk4");
	EVDS_Object_Initialize(solar_system,1);

	//Create planet Earth inertial space
	EVDS_Object_Create(vsfl.evds_system,solar_system,&inertial_earth);
	EVDS_Object_SetName(inertial_earth,"Earth_Inertial_Space");
	EVDS_Object_SetType(inertial_earth,"propagator_rk4");
	EVDS_Object_Initialize(inertial_earth,1);

	//Create planet Earth
	EVDS_Object_Create(vsfl.evds_system,inertial_earth,&planet_earth);
	EVDS_Object_SetType(planet_earth,"planet");
	EVDS_Object_SetName(planet_earth,"Earth");
	EVDS_Object_SetAngularVelocity(planet_earth,inertial_earth,0,0,2*EVDS_PI/86164.0);
	EVDS_Object_AddFloatVariable(planet_earth,"mu",3.9860044e14,0);		//m3 sec-2
	EVDS_Object_AddFloatVariable(planet_earth,"radius",6378.145e3,0);	//m
	EVDS_Object_AddFloatVariable(planet_earth,"period",86164.10,0);		//sec
	EVDS_Object_AddFloatVariable(planet_earth,"is_static",1,0);			//Planet does not move
	EVDS_Object_Initialize(planet_earth,1);

	//Create moon
	EVDS_Object_Create(vsfl.evds_system,inertial_earth,&planet_earth_moon);
	EVDS_Object_SetType(planet_earth_moon,"planet");
	EVDS_Object_SetName(planet_earth_moon,"Moon");
	EVDS_Object_AddFloatVariable(planet_earth_moon,"mu",0.0490277e14,0);	//m3 sec-2
	EVDS_Object_AddFloatVariable(planet_earth_moon,"radius",1737e3,0);		//m
	EVDS_Object_SetPosition(planet_earth_moon,inertial_earth,0.0,362570e3,0.0);
	EVDS_Object_SetVelocity(planet_earth_moon,inertial_earth,1000.0,0.0,0.0);
	EVDS_Object_Initialize(planet_earth_moon,1);

	//Create hangar for storing unlaunched objects
	EVDS_Object_Create(vsfl.evds_system,planet_earth,&hangar_building);
	EVDS_Object_SetName(hangar_building,"Hangar (Baikonur)");
	EVDS_Object_SetType(hangar_building,"building_hangar");
	EVDS_Vector_FromGeographicCoordinates(planet_earth,&vector,45.951,63.497,0);
	EVDS_Object_SetPosition(hangar_building,vector.coordinate_system,vector.x,vector.y,vector.z);
	EVDS_Object_Initialize(hangar_building,1);

	//Start from current time
	vsfl.mjd = SIMC_Thread_GetMJDTime();
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Upload a new file and add vessels from it to database
////////////////////////////////////////////////////////////////////////////////
int VSFL_EVDS_Callback_LoadObject(EVDS_OBJECT_LOADEX* info, EVDS_OBJECT* object) {
	EVDS_Object_Initialize(object,0);
	return EVDS_OK;
}

void VSFL_EVDS_LoadFile(char* filename) {
	EVDS_OBJECT_LOADEX info = {	0 };
	EVDS_OBJECT* hangar_building;

	//Get hangar
	VSFL_Log("mongodb_vessel","Uploading vessel '%s'",filename);
	if (EVDS_System_GetObjectByName(vsfl.evds_system,"Hangar (Baikonur)",0,&hangar_building) != EVDS_OK) {
		VSFL_Log("mongodb_vessel","No hangar for vessel '%s' found!",filename);
		return;
	}

	//Load vessels into the hangar
	info.OnLoadObject = &VSFL_EVDS_Callback_LoadObject;
	if (EVDS_Object_LoadEx(hangar_building,filename,&info) != EVDS_OK) {
		VSFL_Log("mongodb_vessel","Could not read vessel file '%s'",filename);
		return;
	}
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Process vessel information
////////////////////////////////////////////////////////////////////////////////
void VSFL_EVDS_UpdateVesselInformation() {
	SIMC_LIST* list;
	SIMC_LIST_ENTRY* entry;

	if (EVDS_System_GetObjectsByType(vsfl.evds_system,"vessel",&list) == EVDS_OK) {
		entry = SIMC_List_GetFirst(list);
		while (entry) {
			VSFL_MongoDB_UpdateVesselInformation((EVDS_OBJECT*)SIMC_List_GetData(list,entry));
			entry = SIMC_List_GetNext(list,entry);
		}
	}
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Process vessel clocks & statistics
////////////////////////////////////////////////////////////////////////////////
void VSFL_EVDS_UpdateVesselClocks(double time_step) {
	SIMC_LIST* list;
	SIMC_LIST_ENTRY* entry;

	if (EVDS_System_GetObjectsByType(vsfl.evds_system,"vessel",&list) == EVDS_OK) {
		entry = SIMC_List_GetFirst(list);
		while (entry) {
			EVDS_REAL value,altitude,velocity;
			EVDS_VARIABLE* variable;
			EVDS_STATE_VECTOR state;
			EVDS_VECTOR vector;
			EVDS_OBJECT* vessel = (EVDS_OBJECT*)SIMC_List_GetData(list,entry);
			EVDS_OBJECT* planet;

			//Try to get planet
			if (EVDS_Planet_GetNearest(vessel,&planet) != EVDS_OK) {
				entry = SIMC_List_GetNext(list,entry);
				continue;
			}

			//Get state vector to check altitude/position
			EVDS_Object_GetStateVector(vessel,&state);
			EVDS_Vector_Convert(&vector,&state.position,planet);
			EVDS_Vector_Dot(&altitude,&vector,&vector); altitude = sqrt(altitude);
			EVDS_Vector_Convert(&vector,&state.velocity,planet);
			EVDS_Vector_Dot(&velocity,&vector,&vector); velocity = sqrt(velocity);

			//Add total flight time
			if (velocity > 1.0) {
				if (EVDS_Object_GetVariable(vessel,"flight_time",&variable) == EVDS_OK) {
					EVDS_Variable_GetReal(variable,&value);
					EVDS_Variable_SetReal(variable,value + time_step);
				}
			}
			//Add total time in space
			if (altitude > 100.000e3 + 6378.145e3) {
				if (EVDS_Object_GetVariable(vessel,"space_time",&variable) == EVDS_OK) {
					EVDS_Variable_GetReal(variable,&value);
					EVDS_Variable_SetReal(variable,value + time_step);
				}
			}
			//Add total flight distance
			if (EVDS_Object_GetVariable(vessel,"flight_distance",&variable) == EVDS_OK) {
				EVDS_Variable_GetReal(variable,&value);
				EVDS_Variable_SetReal(variable,value + velocity*time_step);
			}

			entry = SIMC_List_GetNext(list,entry);
		}
	}
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Main simulation thread
////////////////////////////////////////////////////////////////////////////////
void VSFL_EVDS_SimulationThread() {
	double late_notify_time = -1e9;

	EVDS_OBJECT* root_inertial_space;
	EVDS_System_GetRootInertialSpace(vsfl.evds_system,&root_inertial_space);
	while (1) {
		double mjd,mjd_offset;
		double time_step,time_step_mjd;

		//Get difference between current time and server time
		mjd = SIMC_Thread_GetMJDTime();
		mjd_offset = mjd - vsfl.mjd;

		//Select simulation precision:
		//	Lag under 1 minute: 60 FPS
		//	Lag above 1 minute: 10 FPS
		if (mjd_offset < 1.0*60.0/86400.0) {
			time_step = 1.0/60.0;
		} else {
			time_step = 1.0/10.0;
		}
		time_step_mjd = time_step/86400.0;

		//Check if state must be propagate
		if (mjd > vsfl.mjd + time_step_mjd) {
			//Enter shared mode
			SIMC_SRW_EnterRead(vsfl.save_lock);

			//Propagate state of objects in the inertial coordinate system
			EVDS_Object_Solve(root_inertial_space,time_step);
			vsfl.mjd += time_step_mjd;

			//Update vessel internal clocks
			VSFL_EVDS_UpdateVesselClocks(time_step);

			//Leave shared mode
			SIMC_SRW_LeaveRead(vsfl.save_lock);

#ifdef _WIN32
			{
				static int counter = 0;
				counter++;
				if (counter % 60 == 0) {
					time_t unix_time = VSFL_MJDToUnix(vsfl.mjd);
					struct tm * timeinfo;

					char buffer[1024] = { 0 };
					timeinfo = localtime(&unix_time);
					strftime(buffer,1023,"VSFL [%x %X]",timeinfo);

					SetConsoleTitle(buffer);
					counter = 0;
				}
			}
#endif
			
			//Warn of late clock (if offset longer than 1 minute, no more often than once per hour)
			if (mjd_offset > 60.0/86400.0) {
				if (SIMC_Thread_GetTime() - late_notify_time > 60.0*60.0) {
					int late_seconds = (int)(mjd_offset*86400.0);
					late_notify_time = SIMC_Thread_GetTime();

					VSFL_Log("late","Server time is %2d days, %02d:%02d:%02d late",
						late_seconds/86400,
						(late_seconds/3600)%24,
						(late_seconds/60)%60,
						late_seconds%60);
				}
			}
		} else {
			SIMC_Thread_Sleep(time_step);
		}
	}
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Utility thread (saving, etc)
////////////////////////////////////////////////////////////////////////////////
void VSFL_EVDS_UtilityThread() {
	double last_save_time = SIMC_Thread_GetTime();
	double last_update_time = SIMC_Thread_GetTime();

	while (1) {
		//Save state if required
		if (SIMC_Thread_GetTime() - last_save_time > 5.0) {
			last_save_time = SIMC_Thread_GetTime();
			VSFL_MongoDB_StoreState();
		}

		//Update vessel information
		if (SIMC_Thread_GetTime() - last_update_time > 1.0) {
			last_update_time = SIMC_Thread_GetTime();
			VSFL_EVDS_UpdateVesselInformation();
		}

		//Do not run services too often
		SIMC_Thread_Sleep(0.1);
	}
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Initialize vessel solver with additional statistics variables
////////////////////////////////////////////////////////////////////////////////
int VSFL_EVDS_OnInitialize(EVDS_SYSTEM* system, EVDS_SOLVER* solver, EVDS_OBJECT* object) {
	//Check object type
	if (EVDS_Object_CheckType(object,"vessel") != EVDS_OK) return EVDS_OK;

	//Add VSFL-specific vessel variables
	EVDS_Object_AddVariable(object,"space_time",EVDS_VARIABLE_TYPE_FLOAT,0);
	EVDS_Object_AddVariable(object,"flight_time",EVDS_VARIABLE_TYPE_FLOAT,0);
	EVDS_Object_AddVariable(object,"day_time",EVDS_VARIABLE_TYPE_FLOAT,0);
	EVDS_Object_AddVariable(object,"night_time",EVDS_VARIABLE_TYPE_FLOAT,0);
	EVDS_Object_AddVariable(object,"flight_distance",EVDS_VARIABLE_TYPE_FLOAT,0);
	return EVDS_OK;
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Initialize EVDS
////////////////////////////////////////////////////////////////////////////////
void VSFL_EVDS_Initialize() {
	//Initialize system
	EVDS_System_Create(&vsfl.evds_system);
	EVDS_Common_Register(vsfl.evds_system);
	EVDS_System_SetCallback_OnInitialize(vsfl.evds_system,VSFL_EVDS_OnInitialize);

	//Create service lock
	vsfl.save_lock = SIMC_SRW_Create();

	//Restore server state
	VSFL_MongoDB_RestoreState();

	//Create simulation thread
	SIMC_Thread_Create(VSFL_EVDS_SimulationThread,0);
	SIMC_Thread_Create(VSFL_EVDS_UtilityThread,0);
	//VSFL_EVDS_LoadFile("stest.evds");
	//VSFL_MongoDB_StoreState();
}