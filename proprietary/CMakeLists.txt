# Install the wrapper as `rastertokpsl`. It resolves the real filter binary
# relative to its own location at runtime, so no prefix is baked in and
# `cmake --install --prefix ...` overrides work correctly.
install(
    PROGRAMS "${CMAKE_CURRENT_LIST_DIR}/wrapper.sh"
    DESTINATION "${KYOCERA_CUPS_FILTER_DIR}"
    COMPONENT proprietary_runtime
    RENAME rastertokpsl
    PERMISSIONS
        OWNER_READ OWNER_WRITE OWNER_EXECUTE
        GROUP_READ GROUP_EXECUTE
        WORLD_READ WORLD_EXECUTE
)

install(
    PROGRAMS "${CMAKE_CURRENT_LIST_DIR}/rastertokpsl_x86"
    DESTINATION "${KYOCERA_CUPS_FILTER_DIR}"
    COMPONENT proprietary_runtime
    PERMISSIONS
        OWNER_READ OWNER_WRITE OWNER_EXECUTE
        GROUP_READ GROUP_EXECUTE
        WORLD_READ WORLD_EXECUTE
)

install(
    PROGRAMS "${CMAKE_CURRENT_LIST_DIR}/rastertokpsl_amd64"
    DESTINATION "${KYOCERA_CUPS_FILTER_DIR}"
    COMPONENT proprietary_runtime
    PERMISSIONS
        OWNER_READ OWNER_WRITE OWNER_EXECUTE
        GROUP_READ GROUP_EXECUTE
        WORLD_READ WORLD_EXECUTE
)
