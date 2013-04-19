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
