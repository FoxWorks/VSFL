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

// EVDS system object
extern EVDS_SYSTEM* evds_system;
//SRW lock that prevents inconsistent state during save
extern SIMC_SRW_ID* save_lock;
// Connection to MongoDB
extern mongo* mongo_connection;

#ifdef __cplusplus
}
#endif
#endif