# GNU Make project makefile autogenerated by Premake
ifndef config
  config=debug32
endif

ifndef verbose
  SILENT = @
endif

ifndef CC
  CC = gcc
endif

ifndef CXX
  CXX = g++
endif

ifndef AR
  AR = ar
endif

ifndef RESCOMP
  ifdef WINDRES
    RESCOMP = $(WINDRES)
  else
    RESCOMP = windres
  endif
endif

ifeq ($(config),debug32)
  OBJDIR     = obj/x32/Debug/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_serverd32.exe
  DEFINES   += -DDEBUG -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/librdrsd32.a ../../bin/libevdsd32.a ../../bin/libmongo-c-driverd32.a -lwsock32
  LDDEPS    += ../../bin/librdrsd32.a ../../bin/libevdsd32.a ../../bin/libmongo-c-driverd32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),release32)
  OBJDIR     = obj/x32/Release/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server32.exe
  DEFINES   += -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/librdrs32.a ../../bin/libevds32.a ../../bin/libmongo-c-driver32.a -lwsock32
  LDDEPS    += ../../bin/librdrs32.a ../../bin/libevds32.a ../../bin/libmongo-c-driver32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugdynamic32)
  OBJDIR     = obj/x32/DebugDynamic/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_serverd32.exe
  DEFINES   += -DDEBUG -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -lrdrsd32 -levdsd32 ../../bin/libmongo-c-driverd32.a -lwsock32
  LDDEPS    += ../../bin/librdrsd32.a ../../bin/libevdsd32.a ../../bin/libmongo-c-driverd32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasedynamic32)
  OBJDIR     = obj/x32/ReleaseDynamic/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server32.exe
  DEFINES   += -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -lrdrs32 -levds32 ../../bin/libmongo-c-driver32.a -lwsock32
  LDDEPS    += ../../bin/librdrs32.a ../../bin/libevds32.a ../../bin/libmongo-c-driver32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugsinglethread32)
  OBJDIR     = obj/x32/DebugSingleThread/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server_std32.exe
  DEFINES   += -DDEBUG -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/librdrs_std32.a ../../bin/libevds_std32.a ../../bin/libmongo-c-driver_std32.a -lwsock32
  LDDEPS    += ../../bin/librdrs_std32.a ../../bin/libevds_std32.a ../../bin/libmongo-c-driver_std32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasesinglethread32)
  OBJDIR     = obj/x32/ReleaseSingleThread/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server_st32.exe
  DEFINES   += -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/librdrs_st32.a ../../bin/libevds_st32.a ../../bin/libmongo-c-driver_st32.a -lwsock32
  LDDEPS    += ../../bin/librdrs_st32.a ../../bin/libevds_st32.a ../../bin/libmongo-c-driver_st32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugsinglethreaddynamic32)
  OBJDIR     = obj/x32/DebugSingleThreadDynamic/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server_std32.exe
  DEFINES   += -DDEBUG -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -lrdrs_std32 -levds_std32 ../../bin/libmongo-c-driver_std32.a -lwsock32
  LDDEPS    += ../../bin/librdrs_std32.a ../../bin/libevds_std32.a ../../bin/libmongo-c-driver_std32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasesinglethreaddynamic32)
  OBJDIR     = obj/x32/ReleaseSingleThreadDynamic/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server_st32.exe
  DEFINES   += -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -lrdrs_st32 -levds_st32 ../../bin/libmongo-c-driver_st32.a -lwsock32
  LDDEPS    += ../../bin/librdrs_st32.a ../../bin/libevds_st32.a ../../bin/libmongo-c-driver_st32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debug64)
  OBJDIR     = obj/x64/Debug/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_serverd.exe
  DEFINES   += -DDEBUG -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/librdrsd.a ../../bin/libevdsd.a ../../bin/libmongo-c-driverd.a -lwsock32
  LDDEPS    += ../../bin/librdrsd.a ../../bin/libevdsd.a ../../bin/libmongo-c-driverd.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),release64)
  OBJDIR     = obj/x64/Release/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server.exe
  DEFINES   += -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/librdrs.a ../../bin/libevds.a ../../bin/libmongo-c-driver.a -lwsock32
  LDDEPS    += ../../bin/librdrs.a ../../bin/libevds.a ../../bin/libmongo-c-driver.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugdynamic64)
  OBJDIR     = obj/x64/DebugDynamic/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_serverd.exe
  DEFINES   += -DDEBUG -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -lrdrsd -levdsd ../../bin/libmongo-c-driverd.a -lwsock32
  LDDEPS    += ../../bin/librdrsd.a ../../bin/libevdsd.a ../../bin/libmongo-c-driverd.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasedynamic64)
  OBJDIR     = obj/x64/ReleaseDynamic/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server.exe
  DEFINES   += -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -lrdrs -levds ../../bin/libmongo-c-driver.a -lwsock32
  LDDEPS    += ../../bin/librdrs.a ../../bin/libevds.a ../../bin/libmongo-c-driver.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugsinglethread64)
  OBJDIR     = obj/x64/DebugSingleThread/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server_std.exe
  DEFINES   += -DDEBUG -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/librdrs_std.a ../../bin/libevds_std.a ../../bin/libmongo-c-driver_std.a -lwsock32
  LDDEPS    += ../../bin/librdrs_std.a ../../bin/libevds_std.a ../../bin/libmongo-c-driver_std.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasesinglethread64)
  OBJDIR     = obj/x64/ReleaseSingleThread/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server_st.exe
  DEFINES   += -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/librdrs_st.a ../../bin/libevds_st.a ../../bin/libmongo-c-driver_st.a -lwsock32
  LDDEPS    += ../../bin/librdrs_st.a ../../bin/libevds_st.a ../../bin/libmongo-c-driver_st.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugsinglethreaddynamic64)
  OBJDIR     = obj/x64/DebugSingleThreadDynamic/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server_std.exe
  DEFINES   += -DDEBUG -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -lrdrs_std -levds_std ../../bin/libmongo-c-driver_std.a -lwsock32
  LDDEPS    += ../../bin/librdrs_std.a ../../bin/libevds_std.a ../../bin/libmongo-c-driver_std.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasesinglethreaddynamic64)
  OBJDIR     = obj/x64/ReleaseSingleThreadDynamic/vsfl_server
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/vsfl_server_st.exe
  DEFINES   += -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64 -DMONGO_HAVE_STDINT -DMONGO_STATIC_BUILD
  INCLUDES  += -I../../external/simc/include -I../../external/evds/include -I../../external/rdrs/include -I../../external/evds/external/simc/include -I../../external/mongo-c-driver/src -I../../external/stdint
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -lrdrs_st -levds_st ../../bin/libmongo-c-driver_st.a -lwsock32
  LDDEPS    += ../../bin/librdrs_st.a ../../bin/libevds_st.a ../../bin/libmongo-c-driver_st.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

OBJECTS := \
	$(OBJDIR)/vsfl_evds.o \
	$(OBJDIR)/vsfl_main.o \
	$(OBJDIR)/vsfl_mongo.o \

RESOURCES := \

SHELLTYPE := msdos
ifeq (,$(ComSpec)$(COMSPEC))
  SHELLTYPE := posix
endif
ifeq (/bin,$(findstring /bin,$(SHELL)))
  SHELLTYPE := posix
endif

.PHONY: clean prebuild prelink

all: $(TARGETDIR) $(OBJDIR) prebuild prelink $(TARGET)
	@:

$(TARGET): $(GCH) $(OBJECTS) $(LDDEPS) $(RESOURCES)
	@echo Linking vsfl_server
	$(SILENT) $(LINKCMD)
	$(POSTBUILDCMDS)

$(TARGETDIR):
	@echo Creating $(TARGETDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) mkdir -p $(TARGETDIR)
else
	$(SILENT) mkdir $(subst /,\\,$(TARGETDIR))
endif

$(OBJDIR):
	@echo Creating $(OBJDIR)
ifeq (posix,$(SHELLTYPE))
	$(SILENT) mkdir -p $(OBJDIR)
else
	$(SILENT) mkdir $(subst /,\\,$(OBJDIR))
endif

clean:
	@echo Cleaning vsfl_server
ifeq (posix,$(SHELLTYPE))
	$(SILENT) rm -f  $(TARGET)
	$(SILENT) rm -rf $(OBJDIR)
else
	$(SILENT) if exist $(subst /,\\,$(TARGET)) del $(subst /,\\,$(TARGET))
	$(SILENT) if exist $(subst /,\\,$(OBJDIR)) rmdir /s /q $(subst /,\\,$(OBJDIR))
endif

prebuild:
	$(PREBUILDCMDS)

prelink:
	$(PRELINKCMDS)

ifneq (,$(PCH))
$(GCH): $(PCH)
	@echo $(notdir $<)
ifeq (posix,$(SHELLTYPE))
	-$(SILENT) cp $< $(OBJDIR)
else
	$(SILENT) xcopy /D /Y /Q "$(subst /,\,$<)" "$(subst /,\,$(OBJDIR))" 1>nul
endif
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
endif

$(OBJDIR)/vsfl_evds.o: ../../source/vsfl_evds.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/vsfl_main.o: ../../source/vsfl_main.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"
$(OBJDIR)/vsfl_mongo.o: ../../source/vsfl_mongo.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"

-include $(OBJECTS:%.o=%.d)
