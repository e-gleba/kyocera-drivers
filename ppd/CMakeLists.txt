cmake_minimum_required(VERSION 3.25)

install(
    DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/English"
    DESTINATION "share/cups/model/Kyocera"
    FILES_MATCHING
    PATTERN "*.ppd")