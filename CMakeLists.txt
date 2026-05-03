cmake_minimum_required(VERSION 3.25)

project(
    kyocera_drivers
    VERSION 1.1.0
    DESCRIPTION "High-performance Kyocera raster-to-KPSL conversion toolkit"
    HOMEPAGE_URL "https://github.com/geugenm/kyocera-drivers"
    LANGUAGES C CXX
)

option(BUILD_TESTS "Enable building of test suite" ON)
option(
    INSTALL_ORIGINAL_PROPRIETARY_DRIVERS
    "Install official proprietary Kyocera drivers"
    ON
)

# NOTE: Kyocera has transitioned to a universal driver model and no longer
# provides per-model manual PPD files through the legacy download endpoints.
# As a result, automated PPD fetching is currently unsupported and disabled
# by default. Use bundled PPDs in the ppd/ directory or obtain drivers
# directly from the manufacturer.
option(DOWNLOAD_PPDS "Download and install Kyocera PPD files" OFF)

list(APPEND CMAKE_PREFIX_PATH cmake)

find_package(package CONFIG REQUIRED)

find_package(clang_format CONFIG REQUIRED)
find_package(clang_tidy CONFIG REQUIRED)
find_package(clang_doc CONFIG REQUIRED)
find_package(cpplint CONFIG REQUIRED)

if(DOWNLOAD_PPDS)
    find_package(kyocera_ppd CONFIG REQUIRED)
else()
    add_subdirectory(ppd)
endif()

if(INSTALL_ORIGINAL_PROPRIETARY_DRIVERS)
    add_subdirectory(proprietary SYSTEM)
else()
    add_subdirectory(src)
endif()

# Integration tests require the open-source rastertokpsl target built from src/.
# They are skipped automatically when the proprietary driver path is selected.
if(BUILD_TESTS AND NOT INSTALL_ORIGINAL_PROPRIETARY_DRIVERS)
    include(CTest)
    add_subdirectory(tests)
endif()
