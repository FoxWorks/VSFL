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
  OBJDIR     = obj/x32/Debug/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorialsd32.exe
  DEFINES   += -DDEBUG -D_CRT_SECURE_NO_WARNINGS -DWIN32
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/libevdsd32.a
  LDDEPS    += ../../bin/libevdsd32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),release32)
  OBJDIR     = obj/x32/Release/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials32.exe
  DEFINES   += -D_CRT_SECURE_NO_WARNINGS -DWIN32
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/libevds32.a
  LDDEPS    += ../../bin/libevds32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugdynamic32)
  OBJDIR     = obj/x32/DebugDynamic/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorialsd32.exe
  DEFINES   += -DDEBUG -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -D_CRT_SECURE_NO_WARNINGS -DWIN32
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -levdsd32
  LDDEPS    += ../../bin/libevdsd32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasedynamic32)
  OBJDIR     = obj/x32/ReleaseDynamic/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials32.exe
  DEFINES   += -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -D_CRT_SECURE_NO_WARNINGS -DWIN32
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -levds32
  LDDEPS    += ../../bin/libevds32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugsinglethread32)
  OBJDIR     = obj/x32/DebugSingleThread/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials_std32.exe
  DEFINES   += -DDEBUG -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/libevds_std32.a
  LDDEPS    += ../../bin/libevds_std32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasesinglethread32)
  OBJDIR     = obj/x32/ReleaseSingleThread/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials_st32.exe
  DEFINES   += -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/libevds_st32.a
  LDDEPS    += ../../bin/libevds_st32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugsinglethreaddynamic32)
  OBJDIR     = obj/x32/DebugSingleThreadDynamic/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials_std32.exe
  DEFINES   += -DDEBUG -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -levds_std32
  LDDEPS    += ../../bin/libevds_std32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasesinglethreaddynamic32)
  OBJDIR     = obj/x32/ReleaseSingleThreadDynamic/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials_st32.exe
  DEFINES   += -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m32
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m32 -L/usr/lib32
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -levds_st32
  LDDEPS    += ../../bin/libevds_st32.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debug64)
  OBJDIR     = obj/x64/Debug/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorialsd.exe
  DEFINES   += -DDEBUG -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/libevdsd.a
  LDDEPS    += ../../bin/libevdsd.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),release64)
  OBJDIR     = obj/x64/Release/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials.exe
  DEFINES   += -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/libevds.a
  LDDEPS    += ../../bin/libevds.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugdynamic64)
  OBJDIR     = obj/x64/DebugDynamic/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorialsd.exe
  DEFINES   += -DDEBUG -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -levdsd
  LDDEPS    += ../../bin/libevdsd.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasedynamic64)
  OBJDIR     = obj/x64/ReleaseDynamic/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials.exe
  DEFINES   += -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -levds
  LDDEPS    += ../../bin/libevds.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugsinglethread64)
  OBJDIR     = obj/x64/DebugSingleThread/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials_std.exe
  DEFINES   += -DDEBUG -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/libevds_std.a
  LDDEPS    += ../../bin/libevds_std.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasesinglethread64)
  OBJDIR     = obj/x64/ReleaseSingleThread/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials_st.exe
  DEFINES   += -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += ../../bin/libevds_st.a
  LDDEPS    += ../../bin/libevds_st.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),debugsinglethreaddynamic64)
  OBJDIR     = obj/x64/DebugSingleThreadDynamic/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials_std.exe
  DEFINES   += -DDEBUG -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -levds_std
  LDDEPS    += ../../bin/libevds_std.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

ifeq ($(config),releasesinglethreaddynamic64)
  OBJDIR     = obj/x64/ReleaseSingleThreadDynamic/evds_tutorials
  TARGETDIR  = ../../bin
  TARGET     = $(TARGETDIR)/evds_tutorials_st.exe
  DEFINES   += -DEVDS_DYNAMIC -DIVSS_DYNAMIC -DRDRS_DYNAMIC -DSIMC_DYNAMIC -DEVDS_SINGLETHREADED -DIVSS_SINGLETHREADED -DRDRS_SINGLETHREADED -DSIMC_SINGLETHREADED -D_CRT_SECURE_NO_WARNINGS -DWIN32 -DWIN64
  INCLUDES  += -I../../external/evds/include -I../../external/evds/external/simc/include -I../../external/evds/source/evds_tutorials
  CPPFLAGS  += -MMD -MP $(DEFINES) $(INCLUDES)
  CFLAGS    += $(CPPFLAGS) $(ARCH) -O2 -g -m64
  CXXFLAGS  += $(CFLAGS) 
  LDFLAGS   += -L../../bin -m64 -L/usr/lib64
  RESFLAGS  += $(DEFINES) $(INCLUDES) 
  LIBS      += -levds_st
  LDDEPS    += ../../bin/libevds_st.a
  LINKCMD    = $(CC) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(ARCH) $(LIBS) $(LDFLAGS)
  define PREBUILDCMDS
  endef
  define PRELINKCMDS
  endef
  define POSTBUILDCMDS
  endef
endif

OBJECTS := \
	$(OBJDIR)/evds_tutorials.o \

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
	@echo Linking evds_tutorials
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
	@echo Cleaning evds_tutorials
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

$(OBJDIR)/evds_tutorials.o: ../../external/evds/source/evds_tutorials/evds_tutorials.c
	@echo $(notdir $<)
	$(SILENT) $(CC) $(CFLAGS) -o "$@" -MF $(@:%.o=%.d) -c "$<"

-include $(OBJECTS:%.o=%.d)
