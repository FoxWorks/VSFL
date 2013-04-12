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


////////////////////////////////////////////////////////////////////////////////
/// @brief Log message to console
////////////////////////////////////////////////////////////////////////////////
void VSFL_Log(char* source, char* text, ...) {
	char buf[8192] = { 0 };
	va_list args;

	va_start(args, text);
	vsnprintf(buf,8191,text,args);
	va_end(args);

	{
		time_t unix_time = VSFL_MJDToUnix(SIMC_Thread_GetMJDTime());
		struct tm * timeinfo;

		char print_buffer[1024] = { 0 };
		char buffer[1024] = { 0 };
		timeinfo = localtime(&unix_time);
		strftime(buffer,1023,"%x %X",timeinfo);
		sprintf(print_buffer,"%s [%s] %s",buffer,source,buf);
		puts(print_buffer);
	}

	//printf("[%.5f][%s] %s\n",SIMC_Thread_GetMJDTime(),source,buf);
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Convert MJD to unix time stamp
////////////////////////////////////////////////////////////////////////////////
time_t VSFL_MJDToUnix(double mjd) {
	return (time_t)((mjd + 2400000.5 - 2440587.5) * 86400.0);
}


////////////////////////////////////////////////////////////////////////////////
/// @brief Main entrypoint
////////////////////////////////////////////////////////////////////////////////
void main() {
	printf("VSFL (Virtual SpaceFlight) Network Server\n");
	printf("--------------------------------------------------------------------------------");
	VSFL_MongoDB_Initialize();
	VSFL_EVDS_Initialize();

	//Read console commands
	while (1) {
		char command[256] = { 0 };
		scanf("%255s",command);

		if (strcmp(command,"upload") == 0) { //Upload vessels
			char filename[256] = { 0 };
			scanf("%255s",filename);

			strcat(filename,".evds");
			VSFL_EVDS_LoadFile(filename);
		} else if (strcmp(command,"list") == 0) { //List of vessels
			VSFL_MongoDB_ListVessels();
		} else {
			VSFL_Log("vsfl","Unknown command %s",command);
		}
		//SIMC_Thread_Sleep(0.0);
	}
}
