find_program(
    clang_tidy_exe
    NAMES clang-tidy
    DOC
        "clang-tidy: clang-based C++ linter. Install: 'sudo dnf install clang-tools-extra', 'sudo apt install clang-tidy', 'brew install llvm', or 'choco install llvm'. Required for 'clang_tidy' target."
)

if(clang_tidy_exe)
    file(
        GLOB_RECURSE
        clang_tidy_sources
        CONFIGURE_DEPENDS
        "${PROJECT_SOURCE_DIR}/src/*.cxx"
        "${PROJECT_SOURCE_DIR}/src/*.c"
        "${PROJECT_SOURCE_DIR}/tests/*.cxx"
        "${PROJECT_SOURCE_DIR}/tests/*.c"
    )

    # Exclude third-party / system subdirectories that are not part of this project.
    list(FILTER clang_tidy_sources EXCLUDE REGEX "(libjbig|unicode|proprietary)")

    add_custom_target(
        clang_tidy
        COMMAND
            "${clang_tidy_exe}"
            -p "${CMAKE_BINARY_DIR}"
            ${clang_tidy_sources}
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        VERBATIM
        COMMENT "running clang-tidy (static analysis and lint) on project sources"
        USES_TERMINAL
    )
else()
    message(
        NOTICE
        "clang-tidy not found. 'clang_tidy' target will not be available.\n"
        "install: sudo dnf install clang-tools-extra | sudo apt install clang-tidy | brew install llvm | choco install llvm"
    )
endif()
