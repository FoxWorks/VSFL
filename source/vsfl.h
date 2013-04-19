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
#ifndef VSFL_H
#define VSFL_H
#ifdef __cplusplus
extern "C" {
#endif

#include <mongo.h>
#include <evds.h>

//Initialize corresponding subsystems
void VSFL_EVDS_Initialize();
void VSFL_EVDS_LoadFile(char* filename);
void VSFL_EVDS_CreateEmptyState();

int VSFL_MongoDB_Initialize();
void VSFL_MongoDB_ListVessels();
void VSFL_MongoDB_UpdateVesselInformation(EVDS_OBJECT* object);
void VSFL_MongoDB_RestoreState();
void VSFL_MongoDB_StoreState();

//Log to console
void VSFL_Log(char* source, char* text, ...);
//Get MJD time
time_t VSFL_MJDToUnix(double mjd);

//Global VSFL object
typedef struct VSFL_EVDS_TAG {
	// EVDS system object
	EVDS_SYSTEM* evds_system;

	// SRW lock that prevents inconsistent state during save
	SIMC_SRW_ID* save_lock;

	// Current server time
	double mjd;
} VSFL_EVDS;

extern VSFL_EVDS vsfl;
extern mongo* mongo_connection;

#ifdef __cplusplus
}
#endif
#endif