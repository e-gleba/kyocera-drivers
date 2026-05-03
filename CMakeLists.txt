cmake_minimum_required(VERSION 3.25)

project(
    kyocera_drivers
    VERSION 1.1.0
    DESCRIPTION "High-performance Kyocera raster-to-KPSL conversion toolkit"
    HOMEPAGE_URL "https://github.com/geugenm/kyocera-drivers"
    LANGUAGES C CXX)

include(GNUInstallDirs)

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

if(DOWNLOAD_PPDS)
    find_package(download_kyocera_ppd CONFIG REQUIRED)
else()
    add_subdirectory(ppd SYSTEM)
endif()

add_subdirectory(proprietary SYSTEM)

# todo: make it real
if(FALSE)
    include(CMakePackageConfigHelpers)

    # no such file, so autogenerate some
    configure_package_config_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake/kyocera_driversConfig.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/kyocera_driversConfig.cmake"
        INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/kyocera_drivers)

    write_basic_package_version_file(
        "${CMAKE_CURRENT_BINARY_DIR}/kyocera_driversConfigVersion.cmake"
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY SameMajorVersion)

    install(
        FILES "${CMAKE_CURRENT_BINARY_DIR}/kyocera_driversConfig.cmake"
              "${CMAKE_CURRENT_BINARY_DIR}/kyocera_driversConfigVersion.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/kyocera_drivers
        COMPONENT development)
endif()

if(PROJECT_IS_TOP_LEVEL)
    set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
    set(CPACK_PACKAGE_VENDOR "Kyocera Reverse Engineering Team")
    set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/description.txt")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
        "High-performance Kyocera raster-to-KPSL conversion toolkit")
    set(CPACK_PACKAGE_CONTACT "glebajk@gmail.com")
    set(CPACK_PACKAGE_ICON "${CMAKE_CURRENT_LIST_DIR}/package/icon.png")
    set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/license")
    set(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/readme.md")
    set(CPACK_RESOURCE_FILE_WELCOME "${CMAKE_SOURCE_DIR}/readme.md")

    # RPM
    set(CPACK_RPM_PACKAGE_DESCRIPTION
        "High-performance Kyocera raster-to-KPSL conversion toolkit. See README.md for details."
    )
    set(CPACK_RPM_PACKAGE_LICENSE "GPLv3")
    set(CPACK_RPM_PACKAGE_GROUP "System/Printing")
    set(CPACK_RPM_PACKAGE_ARCHITECTURE "x86_64")
    set(CPACK_RPM_COMPONENT_INSTALL ON)

    # DEB
    set(CPACK_DEBIAN_PACKAGE_DESCRIPTION
        "High-performance Kyocera raster-to-KPSL conversion toolkit. See README.md for details."
    )
    set(CPACK_DEBIAN_PACKAGE_SECTION "utils")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "glebajk@gmail.com")
    set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "amd64")
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "cups;libc6")
    set(CPACK_DEB_COMPONENT_INSTALL ON)

    include(CPack)

    cpack_add_component(
        proprietary_runtime
        DISPLAY_NAME "Proprietary Runtime"
        DESCRIPTION "Kyocera rastertokpsl wrapper and binaries"
        REQUIRED)

    cpack_add_component(
        documentation
        DISPLAY_NAME "Documentation"
        DESCRIPTION "Project README and documentation"
        GROUP "Documentation"
        REQUIRED)

endif()
