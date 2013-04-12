////////////////////////////////////////////////////////////////////////////////
/// @file
///
/// @brief Virtual SpaceFlight Network
////////////////////////////////////////////////////////////////////////////////
/// Copyright (C) 2012-2013, Black Phoenix
/// All rights reserved.
///
/// Redistribution and use in source and binary forms, with or without
/// modification, are permitted provided that the following conditions are met:
///   - Redistributions of source code must retain the above copyright
///     notice, this list of conditions and the following disclaimer.
///   - Redistributions in binary form must reproduce the above copyright
///     notice, this list of conditions and the following disclaimer in the
///     documentation and/or other materials provided with the distribution.
///   - Neither the name of the author nor the names of the contributors may
///     be used to endorse or promote products derived from this software without
///     specific prior written permission.
///
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
/// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
/// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
/// DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS BE LIABLE FOR ANY
/// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
/// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
/// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
/// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
/// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
/// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
	//Create planet Earth inertial space
	EVDS_Object_Create(vsfl.evds_system,vsfl.solar_system,&vsfl.inertial_earth);
	EVDS_Object_SetName(vsfl.inertial_earth,"Earth_Inertial_Space");
	EVDS_Object_SetType(vsfl.inertial_earth,"propagator_rk4");
	EVDS_Object_Initialize(vsfl.inertial_earth,1);

	//Create planet Earth
	EVDS_Object_Create(vsfl.evds_system,vsfl.inertial_earth,&vsfl.planet_earth);
	EVDS_Object_SetType(vsfl.planet_earth,"planet");
	EVDS_Object_SetName(vsfl.planet_earth,"Earth");
	EVDS_Object_SetAngularVelocity(vsfl.planet_earth,vsfl.inertial_earth,0,0,2*EVDS_PI/86164.0);
	EVDS_Object_AddFloatVariable(vsfl.planet_earth,"mu",3.9860044e14,0);	//m3 sec-2
	EVDS_Object_AddFloatVariable(vsfl.planet_earth,"radius",6378.145e3,0);	//m
	EVDS_Object_AddFloatVariable(vsfl.planet_earth,"period",86164.10,0);	//sec
	EVDS_Object_Initialize(vsfl.planet_earth,1);

	//Create moon
	EVDS_Object_Create(vsfl.evds_system,vsfl.inertial_earth,&vsfl.planet_earth_moon);
	EVDS_Object_SetType(vsfl.planet_earth_moon,"planet");
	EVDS_Object_SetName(vsfl.planet_earth_moon,"Moon");
	EVDS_Object_AddFloatVariable(vsfl.planet_earth_moon,"mu",0.0490277e14,0);	//m3 sec-2
	EVDS_Object_AddFloatVariable(vsfl.planet_earth_moon,"radius",1737e3,0);	//m
	EVDS_Object_SetPosition(vsfl.planet_earth_moon,vsfl.inertial_earth,0.0,362570e3,0.0);
	EVDS_Object_SetVelocity(vsfl.planet_earth_moon,vsfl.inertial_earth,1000.0,0.0,0.0);
	EVDS_Object_Initialize(vsfl.planet_earth_moon,1);

	//Create hangar for storing unlaunched objects
	EVDS_Object_Create(vsfl.evds_system,vsfl.planet_earth,&vsfl.hangar_building);
	EVDS_Object_SetName(vsfl.hangar_building,"Hangar");
	//EVDS_Object_SetType(vsfl.hangar_building,"");
	EVDS_Object_SetPosition(vsfl.hangar_building,vsfl.planet_earth,6378.145e3,0,0);
	EVDS_Object_Initialize(vsfl.hangar_building,1);

	//Start from current time
	vsfl.mjd = SIMC_Thread_GetMJDTime();
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Upload a new file and add vessels from it to database
////////////////////////////////////////////////////////////////////////////////
void VSFL_EVDS_LoadFile(char* filename) {
	EVDS_OBJECT_LOADEX info = {	0 };

	//Load vessels into the hangar
	VSFL_Log("mongodb_vessel","Uploading vessel '%s'",filename);
	if (EVDS_Object_LoadEx(vsfl.hangar_building,filename,&info) != EVDS_OK) {
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

			//Get state vector to check altitude/position
			EVDS_Object_GetStateVector(vessel,&state);
			EVDS_Vector_Convert(&vector,&state.position,vsfl.planet_earth);
			EVDS_Vector_Dot(&altitude,&vector,&vector); altitude = sqrt(altitude);
			EVDS_Vector_Convert(&vector,&state.velocity,vsfl.planet_earth);
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
			EVDS_Object_Solve(vsfl.solar_system,time_step);
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

	//Create solar system inertial space
	EVDS_Object_Create(vsfl.evds_system,0,&vsfl.solar_system);
	EVDS_Object_SetName(vsfl.solar_system,"Solar_Inertial_Space");
	EVDS_Object_SetType(vsfl.solar_system,"propagator_rk4");
	EVDS_Object_Initialize(vsfl.solar_system,1);

	//Restore server state
	VSFL_MongoDB_RestoreState();

	//Create simulation thread
	SIMC_Thread_Create(VSFL_EVDS_SimulationThread,0);
	SIMC_Thread_Create(VSFL_EVDS_UtilityThread,0);
	//VSFL_EVDS_LoadFile("stest.evds");
	//VSFL_MongoDB_StoreState();
}