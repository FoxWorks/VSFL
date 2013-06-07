SIMC_STANDALONE = false
EVDS_STANDALONE = false
RDRS_STANDALONE = false
solution "vsfl"
   debugdir "../debug"
   dofile("./../external/simc/support/premake4_common.lua")
   dofile("./../external/simc/support/premake4.lua")
   dofile("./../external/evds/support/premake4.lua")
   dofile("./../external/rdrs/support/premake4.lua")
   
-- Create working directory
if not os.isdir("../debug") then os.mkdir("../debug") end


--------------------------------------------------------------------------------
-- Virtual Space FLight Network Server
--------------------------------------------------------------------------------
   project("mongo-c-driver")
      uuid "47AD2AB0-C848-4346-8A79-2BC76324294B"
      kind "StaticLib"
      language "C"
      includedirs {
        "../external/mongo-c-driver/src",
      }
      files {
        "../external/mongo-c-driver/src/*.c",
        "../external/mongo-c-driver/src/*.h",
      }
      defines { "MONGO_HAVE_STDINT", "MONGO_STATIC_BUILD", "snprintf=_snprintf" }
      
      configuration "windows"
         includedirs { "../external/stdint" }
      

   project "vsfl_server"
      uuid "C84AD4D2-2D63-1842-871E-30B7C71BEA58"
      kind "ConsoleApp"
      language "C"
      includedirs {
        "../external/simc/include",
        "../external/evds/include",
        "../external/rdrs/include",
        "../external/evds/addons",
        "../external/mongo-c-driver/src",
        "../external/nrlmsise-00",
      }
      files {
        "../source/**",
        "../external/evds/addons/evds_antenna.c",
        "../external/evds/addons/evds_antenna.h",
        "../external/evds/addons/evds_nrlmsise-00.c",
        "../external/evds/addons/evds_nrlmsise-00.h",
        "../external/nrlmsise-00/nrlmsise-00.c",
        "../external/nrlmsise-00/nrlmsise-00_data.c",
      }

      defines { "MONGO_HAVE_STDINT", "MONGO_STATIC_BUILD" }
      links { "rdrs","evds","simc","mongo-c-driver" }
      
      configuration "windows"
         links { "wsock32" }
         includedirs { "../external/stdint" }
