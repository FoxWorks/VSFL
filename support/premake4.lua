SIMC_STANDALONE = false
EVDS_STANDALONE = false
RDRS_STANDALONE = false
solution "vsfl"
   dofile("./../external/simc/support/premake4_common.lua")
   dofile("./../external/simc/support/premake4.lua")
   dofile("./../external/evds/support/premake4.lua")
   dofile("./../external/rdrs/support/premake4.lua")


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
      defines { "MONGO_HAVE_STDINT", "MONGO_STATIC_BUILD" }
      
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
        "../external/evds/external/simc/include",
        "../external/mongo-c-driver/src",
      }
      files { "../source/**" }

      defines { "MONGO_HAVE_STDINT", "MONGO_STATIC_BUILD" }
      links { "rdrs","evds","mongo-c-driver" }

      configuration "windows"
         links { "wsock32" }
         includedirs { "../external/stdint" }
      configuration "not windows"
         links { "simc", "tinyxml" }
