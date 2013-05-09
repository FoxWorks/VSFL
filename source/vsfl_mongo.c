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
#include "vsfl.h"


// Connection to MongoDB database
mongo* mongo_connection;


////////////////////////////////////////////////////////////////////////////////
/// @brief Initialize MongoDB
////////////////////////////////////////////////////////////////////////////////
int VSFL_MongoDB_Initialize() {
	int error_code;

	mongo_connection = (mongo*)malloc(sizeof(mongo));
	mongo_init_sockets();
	mongo_init(mongo_connection);
	mongo_set_op_timeout(mongo_connection,5000);

	error_code = mongo_client(mongo_connection, "127.0.0.1", 27017);
	if (error_code != MONGO_OK) {
		VSFL_Log("mongodb","Connection error: %s",mongo_connection->errstr);
		return 0;
	} else {
		VSFL_Log("mongodb","Connected to localhost");
		return 1;
	}
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Verify connection is still established
////////////////////////////////////////////////////////////////////////////////
int VSFL_MongoDB_CheckConnection() {
	if (mongo_check_connection(mongo_connection) != MONGO_OK) {
		VSFL_Log("mongodb","No connection to database");
		SIMC_Thread_Sleep(5.0);
		return VSFL_MongoDB_Initialize();
	} else {
		return 1;
	}
}


////////////////////////////////////////////////////////////////////////////////
/// @brief List all vessels in database
////////////////////////////////////////////////////////////////////////////////
void VSFL_MongoDB_ListVessels() {
	mongo_cursor cursor[1];
	if (!VSFL_MongoDB_CheckConnection()) return;

	mongo_cursor_init(cursor, mongo_connection, "vsfl.vessels");

	VSFL_Log("vessel","Vessels list:");
	while (mongo_cursor_next(cursor) == MONGO_OK) {
		bson_iterator iterator[2];
		if (bson_find(&iterator[0],mongo_cursor_bson(cursor),"name") &&
			bson_find(&iterator[1],mongo_cursor_bson(cursor),"uid")) {
			VSFL_Log("vessel","[%05d] %s",
				bson_iterator_int(&iterator[1]),
				bson_iterator_string(&iterator[0]));
		} else {
			VSFL_Log("vessel","[-----] <undefined vessel>");
		}
	}

	mongo_cursor_destroy(cursor);
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Assign unique ID to the vessel
////////////////////////////////////////////////////////////////////////////////
//void VSFL_MongoDB_AssignUniqueID(EVDS_OBJECT* object) {
//
//}


////////////////////////////////////////////////////////////////////////////////
/// @brief Update vessel information in the database
////////////////////////////////////////////////////////////////////////////////
void VSFL_MongoDB_UpdateVesselInformation(EVDS_OBJECT* object) {
	unsigned int uid;
	char name[256] = { 0 };
	char type[256] = { 0 };
	bson query[1];
	bson op[1];
	mongo_cursor cursor[1];
	EVDS_VARIABLE* variable;
	EVDS_REAL value;

	if (!VSFL_MongoDB_CheckConnection()) return;
	
	//Get more vessel info
	EVDS_Object_GetName(object,name,255);
	EVDS_Object_GetType(object,type,255);
	EVDS_Object_GetUID(object,&uid);

	//Generate new UID unless specified explicitly
	if (uid > 99999) {
		//Create query for counter
		bson_init(query);
		bson_append_string(query, "counter_name", "uid_counter");
		bson_finish(query);

		//Execute query
		mongo_cursor_init(cursor, mongo_connection, "vsfl.system");
		mongo_cursor_set_query(cursor, query);
		if (mongo_cursor_next(cursor) == MONGO_OK) {
			bson_iterator iterator[1];
			if (bson_find(iterator,mongo_cursor_bson(cursor),"value")) {
				uid = bson_iterator_int(iterator);
			} else {
				uid = 12345; //FIXME
			}
		} else { //Create counter
			bson_init(op);
			bson_append_string(op, "counter_name", "uid_counter");
			bson_append_int(op, "value", 1);
			bson_finish(op);
			mongo_insert(mongo_connection, "vsfl.system", op, 0);

			uid = 1;
		}

		//Create query to update counter
		bson_init(op);
		bson_append_start_object( op, "$inc" );
			bson_append_int( op, "value", 1 );
		bson_append_finish_object( op );
		bson_finish(op);
		mongo_update(mongo_connection, "vsfl.system", query, op, MONGO_UPDATE_BASIC, 0);

		//Set new ID
		EVDS_Object_SetUID(object,uid);
	}

	//Query if object exists in database
	bson_init(query);
	bson_append_int(query, "uid", uid);
	bson_finish(query);

	//Execute query
	mongo_cursor_init(cursor, mongo_connection, "vsfl.vessels");
	mongo_cursor_set_query(cursor, query);
	if (mongo_cursor_next(cursor) != MONGO_OK) { //Create new registration
		VSFL_Log("vessel","Registered new vessel [%05d] %s",uid,name);

		bson_init(op);
		bson_append_new_oid	(op, "_id");
		bson_append_int		(op, "uid", uid);
		bson_append_string	(op, "vessel_name", name);
		bson_append_time_t	(op, "register_time", time(0));
	
		bson_append_string	(op, "name", name);
		bson_append_string	(op, "vsa", "XSAG");
		bson_append_string	(op, "status", "hangar");
		bson_append_string	(op, "description", "");
		bson_finish(op);

		//Add new entry
		mongo_insert(mongo_connection, "vsfl.vessels", op, 0);
	}

	//Update registration info
	bson_init(op);
	bson_append_start_object(op,"$set");
		if (EVDS_Object_GetVariable(object,"space_time",&variable) == EVDS_OK) { EVDS_Variable_GetReal(variable,&value);
			bson_append_double(op, "stats.space_time", value);
		}
		if (EVDS_Object_GetVariable(object,"flight_time",&variable) == EVDS_OK) { EVDS_Variable_GetReal(variable,&value);
			bson_append_double(op, "stats.flight_time", value);
		}
		if (EVDS_Object_GetVariable(object,"day_time",&variable) == EVDS_OK) { EVDS_Variable_GetReal(variable,&value);
			bson_append_double(op, "stats.day_time", value);
		}
		if (EVDS_Object_GetVariable(object,"night_time",&variable) == EVDS_OK) { EVDS_Variable_GetReal(variable,&value);
			bson_append_double(op, "stats.night_time", value);
		}
		if (EVDS_Object_GetVariable(object,"flight_distance",&variable) == EVDS_OK) { EVDS_Variable_GetReal(variable,&value);
			bson_append_double(op, "stats.flight_distance", value);
		}
	bson_append_finish_object(op);
	bson_finish(op);
	mongo_update(mongo_connection, "vsfl.vessels", query, op, MONGO_UPDATE_BASIC, 0);


	/*bson_append_start_object(op,"stats");
		bson_append_double	(op, "space_time", 0.0);
		bson_append_double	(op, "flight_time", 0.0);
		bson_append_double	(op, "day_time", 0.0);
		bson_append_double	(op, "night_time", 0.0);
		bson_append_double	(op, "flight_distance", 0.0);
	bson_append_finish_object(b);
	bson_append_start_object(op,"state");
		bson_append_double	(op, "latitude", 0.0);
		bson_append_double	(op, "longitude", 0.0);
		bson_append_double	(op, "elevation", 0.0);
		bson_append_double	(op, "velocity", 0.0);
	bson_append_finish_object(b);
	bson_append_start_object(op,"orbit");
		bson_append_double	(op, "epoch", 0.0); //Orbital elements
		bson_append_double	(op, "eccentricity", 0.0);
		bson_append_double	(op, "inclination", 0.0);
		bson_append_double	(op, "ascending_node", 0.0);
		bson_append_double	(op, "semimajor_axis", 0.0);
		bson_append_double	(op, "mean_anomaly", 0.0);
		bson_append_double	(op, "periapsis_arg", 0.0);
		bson_append_double	(op, "bstar", 0.0); //Extra information
		bson_append_double	(op, "period", 0.0);
		bson_append_double	(op, "mean_apoapsis", 0.0);
		bson_append_double	(op, "mean_periapsis", 0.0);
	bson_append_finish_object(b);*/
	//bson_finish(op);

}


////////////////////////////////////////////////////////////////////////////////
/// @brief Restore simulation state from database
////////////////////////////////////////////////////////////////////////////////
void VSFL_MongoDB_RestoreState() {
	bson query[1];
	mongo_cursor cursor[1];
	while (!VSFL_MongoDB_CheckConnection()) {
		//VSFL_Log("load_state","Error: Cannot start server with no connection to database!");
		//exit(1);//return;
		SIMC_Thread_Sleep(1.0);
	}

	//Create query for counter
	bson_init(query);
	bson_append_start_object(query, "$query");
	bson_append_finish_object(query);
	bson_append_start_object(query, "$orderby");
		bson_append_int(query,"mjd_time",-1);
	bson_append_finish_object(query);
	bson_finish(query);

	//Try to restore state from query
	mongo_cursor_init(cursor, mongo_connection, "vsfl.states");
	mongo_cursor_set_query(cursor, query);
	if (mongo_cursor_next(cursor) == MONGO_OK) {
		bson_iterator iterator[2];
		if (bson_find(&iterator[0],mongo_cursor_bson(cursor),"mjd_time") &&
			bson_find(&iterator[1],mongo_cursor_bson(cursor),"xml")) {

			//Load data
			EVDS_OBJECT* root_inertial_space;
			EVDS_System_GetRootInertialSpace(evds_system,&root_inertial_space);
			EVDS_Object_LoadFromString(root_inertial_space,bson_iterator_string(&iterator[1]),0);

			//Update time
			EVDS_System_SetTime(evds_system,bson_iterator_double(&iterator[0]));
			
			{
				time_t unix_time = VSFL_MJDToUnix(bson_iterator_double(&iterator[0]));
				struct tm * timeinfo;
				char buffer[1024] = { 0 };
				timeinfo = localtime(&unix_time);
				strftime(buffer,1023,"%x %X",timeinfo);
				VSFL_Log("load_state","Restoring state from %s",buffer);
			}
		}
	} else {
		VSFL_Log("load_state","Creating empty world state");

		//Create new empty state
		VSFL_EVDS_CreateEmptyState();
		//Save state
		VSFL_MongoDB_StoreState();
	}
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Save simulation state to the database
////////////////////////////////////////////////////////////////////////////////
void VSFL_MongoDB_StoreState() {
	double vsfl_mjd;
	EVDS_OBJECT* root_inertial_space;
	EVDS_OBJECT_SAVEEX info = { 0 };
	bson op[1];
	if (!VSFL_MongoDB_CheckConnection()) return;

	//Setup saving parameters
	info.flags = EVDS_OBJECT_SAVEEX_SAVE_FULL_STATE | 
				 EVDS_OBJECT_SAVEEX_ONLY_CHILDREN | 
				 EVDS_OBJECT_SAVEEX_SAVE_UIDS;

	//Enter exclusive mode
	SIMC_SRW_EnterWrite(save_lock);

	//Save solar system state
	EVDS_System_GetRootInertialSpace(evds_system,&root_inertial_space);
	if (EVDS_Object_SaveEx(root_inertial_space,0,&info) != EVDS_OK) {
		VSFL_Log("save_state","Could not store server state");
		return;
	}

	//Leave exclusive mode
	SIMC_SRW_LeaveWrite(save_lock);

	//Get state snapshot
	EVDS_System_GetTime(evds_system,&vsfl_mjd);
	VSFL_Log("save_state","Save server state (%f)",vsfl_mjd);
	{
		FILE* f = fopen("state_test.txt","w+");
		fprintf(f,"%s",info.description);
		fclose(f);
	}

	//Remove old states
	bson_init(op);
	bson_append_start_object(op, "mjd_time");
		bson_append_double(op, "$lt", vsfl_mjd-60.0/86400.0); //Keeps last minute worth of states
	bson_append_finish_object(op);
	bson_finish(op);
	mongo_remove(mongo_connection, "vsfl.states", op, 0);

	//Write state to database
	bson_init(op);
	bson_append_time_t(op, "real_time", time(0));
	bson_append_double(op, "mjd_time", vsfl_mjd);
	bson_append_string(op, "xml", info.description);
	bson_finish(op);
	mongo_insert(mongo_connection, "vsfl.states", op, 0);
}