find_program(
    clang_format_exe
    NAMES clang-format
    DOC
        "clang-format: automatic C/C++ code formatter. Install: 'sudo dnf install clang-tools-extra', 'sudo apt install clang-format', 'brew install llvm', or 'choco install llvm'. Required for 'clang_format' and 'clang_format_check' targets."
)

if(clang_format_exe)
    file(
        GLOB_RECURSE
        clang_format_sources
        CONFIGURE_DEPENDS
        "${PROJECT_SOURCE_DIR}/src/*.cxx"
        "${PROJECT_SOURCE_DIR}/src/*.c"
        "${PROJECT_SOURCE_DIR}/src/*.h"
        "${PROJECT_SOURCE_DIR}/tests/*.cxx"
        "${PROJECT_SOURCE_DIR}/tests/*.c"
        "${PROJECT_SOURCE_DIR}/tests/*.h"
    )

    # Exclude third-party / system subdirectories that are not part of this project.
    list(FILTER clang_format_sources EXCLUDE REGEX "(libjbig|unicode|proprietary)")

    add_custom_target(
        clang_format
        COMMAND "${clang_format_exe}" -i ${clang_format_sources}
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        VERBATIM
        COMMENT "running clang-format (in-place formatting) on project sources"
        USES_TERMINAL
    )

    add_custom_target(
        clang_format_check
        COMMAND "${clang_format_exe}" --dry-run --Werror ${clang_format_sources}
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        VERBATIM
        COMMENT "running clang-format check (dry-run, fail on format violations)"
        USES_TERMINAL
    )
else()
    message(
        NOTICE
        "clang-format not found. 'clang_format' and 'clang_format_check' targets will not be available.\n"
        "install: sudo dnf install clang-tools-extra | sudo apt install clang-format | brew install llvm | choco install llvm"
    )
endif()
