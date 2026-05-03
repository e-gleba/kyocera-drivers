find_program(
    cpplint_exe
    NAMES cpplint
    DOC
        "cpplint: C++ style checker. Install via 'pip install cpplint', 'sudo dnf install cpplint', or 'brew install cpplint'. Required for 'cpplint' target."
)

if(cpplint_exe)
    file(
        GLOB_RECURSE
        cpplint_sources
        CONFIGURE_DEPENDS
        "${PROJECT_SOURCE_DIR}/src/*.cxx"
        "${PROJECT_SOURCE_DIR}/src/*.c"
        "${PROJECT_SOURCE_DIR}/src/*.h"
        "${PROJECT_SOURCE_DIR}/tests/*.cxx"
        "${PROJECT_SOURCE_DIR}/tests/*.c"
        "${PROJECT_SOURCE_DIR}/tests/*.h"
    )

    # Exclude third-party / system subdirectories.
    list(FILTER cpplint_sources EXCLUDE REGEX "(libjbig|unicode|proprietary)")

    add_custom_target(
        cpplint
        COMMAND "${cpplint_exe}" ${cpplint_sources}
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        VERBATIM
        COMMENT "running cpplint (Google C++ style checker) on project sources"
        USES_TERMINAL
    )
else()
    message(
        NOTICE
        "cpplint not found. 'cpplint' target will not be available.\n"
        "install: pip install cpplint | sudo dnf install cpplint | brew install cpplint"
    )
endif()
