cmake_minimum_required(VERSION 3.25)

project(
    kyocera_drivers
    VERSION 1.1.0
    DESCRIPTION "High-performance Kyocera raster-to-KPSL conversion toolkit"
    HOMEPAGE_URL "https://github.com/geugenm/kyocera-drivers"
    LANGUAGES C CXX)

if(NOT
   CMAKE_SYSTEM_NAME
   STREQUAL
   "Linux")
    message(
        FATAL_ERROR
            "This project supports Linux x86_64 only. Detected: ${CMAKE_SYSTEM_NAME}"
        )
endif()

# NOTE: Kyocera has transitioned to a universal driver model and no longer
# provides per-model manual PPD files through the legacy download endpoints.
# As a result, automated PPD fetching is currently unsupported and disabled
# by default. Use bundled PPDs in the ppd/ directory or obtain drivers
# directly from the manufacturer.
option(DOWNLOAD_PPDS "Download and install Kyocera PPD files" OFF)

list(APPEND CMAKE_PREFIX_PATH cmake)

find_package(package CONFIG REQUIRED)

if(DOWNLOAD_PPDS)
    find_package(kyocera_ppd CONFIG REQUIRED)
else()
    add_subdirectory(ppd SYSTEM)
endif()

add_subdirectory(proprietary SYSTEM)
