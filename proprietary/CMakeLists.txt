cmake_minimum_required(VERSION 3.16)

# WARNING THOSE paths are hardocde for install for correct cups, so if use gnu
# do with warn

# Install wrapper.sh as rastertokpsl (runtime component)
install(
    PROGRAMS "${CMAKE_CURRENT_LIST_DIR}/wrapper.sh"
    DESTINATION lib/cups/filter
    # we need that rename for driver to substicute and think its exe
    RENAME rastertokpsl
    COMPONENT proprietary_runtime
    PERMISSIONS
        OWNER_READ
        OWNER_WRITE
        OWNER_EXECUTE
        GROUP_READ
        GROUP_EXECUTE
        WORLD_READ
        WORLD_EXECUTE)

# Install rastertokpsl-x32 binary (runtime component)
install(
    PROGRAMS "${CMAKE_CURRENT_LIST_DIR}/rastertokpsl_x86"
    DESTINATION lib/cups/filter
    COMPONENT proprietary_runtime
    PERMISSIONS
        OWNER_READ
        OWNER_WRITE
        OWNER_EXECUTE
        GROUP_READ
        GROUP_EXECUTE
        WORLD_READ
        WORLD_EXECUTE)

# Install rastertokpsl-x64 binary (runtime component)
install(
    PROGRAMS "${CMAKE_CURRENT_LIST_DIR}/rastertokpsl_amd64"
    DESTINATION lib/cups/filter
    COMPONENT proprietary_runtime
    PERMISSIONS
        OWNER_READ
        OWNER_WRITE
        OWNER_EXECUTE
        GROUP_READ
        GROUP_EXECUTE
        WORLD_READ
        WORLD_EXECUTE)
