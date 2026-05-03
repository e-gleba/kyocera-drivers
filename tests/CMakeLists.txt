# tests/CMakeLists.txt
# Integration tests for the rastertokpsl CUPS filter pipeline.
# These are end-to-end tests that exercise the full PDF -> raster -> KPSL
# conversion chain using the open-source driver built from src/.
# -----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.25)

# The test executables and their symlinks are placed in the same directory so
# that the integration tests can reference ./rastertokpsl relatively.
set(TEST_RUNTIME_DIR "$<TARGET_FILE_DIR:test_raster>")

# -----------------------------------------------------------------------------
# raster_chain: PDF -> CUPS raster -> KPSL (direct filter invocation)
# -----------------------------------------------------------------------------
add_executable(test_raster test_raster.cxx)
set_target_properties(test_raster
    PROPERTIES
        CXX_STANDARD 26
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
)

# Ensure the open-source filter is built before the test binary.
add_dependencies(test_raster rastertokpsl)

# Symlink the built filter into the test working directory.
add_custom_command(
    TARGET test_raster POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E create_symlink
        $<TARGET_FILE:rastertokpsl>
        ${TEST_RUNTIME_DIR}/rastertokpsl
    COMMENT "Linking rastertokpsl into test runtime directory"
)

# Symlink test input data into the test working directory.
add_custom_command(
    TARGET test_raster POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E create_symlink
        "${CMAKE_CURRENT_SOURCE_DIR}/test.pdf"
        ${TEST_RUNTIME_DIR}/test.pdf
    COMMENT "Linking test.pdf into test runtime directory"
)

add_test(
    NAME raster_chain
    COMMAND $<TARGET_FILE:test_raster>
    WORKING_DIRECTORY ${TEST_RUNTIME_DIR}
)

set_tests_properties(raster_chain
    PROPERTIES
        TIMEOUT 60
        LABELS "integration;filter"
)

# -----------------------------------------------------------------------------
# filter_chain: Full CUPS pipeline via cupsfilter + PPD
# -----------------------------------------------------------------------------
add_executable(test_filter test_filter.cxx)
set_target_properties(test_filter
    PROPERTIES
        CXX_STANDARD 26
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS OFF
)

add_dependencies(test_filter rastertokpsl)

# Symlink the PPD used by the filter test.
add_custom_command(
    TARGET test_filter POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E create_symlink
        "${CMAKE_CURRENT_SOURCE_DIR}/../ppd/English/Kyocera_FS-1020MFPGDI.ppd"
        ${TEST_RUNTIME_DIR}/Kyocera_FS-1020MFPGDI.ppd
    COMMENT "Linking Kyocera_FS-1020MFPGDI.ppd into test runtime directory"
)

# Re-use the same test.pdf symlink created for test_raster (same runtime dir).
# If test_raster is not built, create it here as well for standalone builds.
add_custom_command(
    TARGET test_filter POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E create_symlink
        "${CMAKE_CURRENT_SOURCE_DIR}/test.pdf"
        ${TEST_RUNTIME_DIR}/test.pdf
    COMMENT "Linking test.pdf into test runtime directory"
)

add_test(
    NAME filter_chain
    COMMAND $<TARGET_FILE:test_filter>
    WORKING_DIRECTORY ${TEST_RUNTIME_DIR}
)

set_tests_properties(filter_chain
    PROPERTIES
        TIMEOUT 60
        LABELS "integration;cups"
)
