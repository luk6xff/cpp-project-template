#----------------------------------------------------------------------------------
# Test setup common

# Get test dir name
get_filename_component(TEST_NAME_DIR "${CMAKE_CURRENT_SOURCE_DIR}" NAME)

#----------------------------------------------------------------------------------
# Resolution test
set(APP_LIB_NAME Resolution)

# Add all the sources to the library
set(APP_SOURCES
    ${APP_DIR}/Configuration/Resolution.cpp
)

set(APP_INCLUDES
    ${APP_DIR}/Configuration
)

set(APP_LINK_LIBS
    ""
)

set(TEST_SOURCES
    ResolutionTest.cpp
)

add_unit_test(
    ${APP_LIB_NAME}
    ${APP_DIR}
    "${APP_SOURCES}"
    "${APP_INCLUDES}"
    "${APP_LINK_LIBS}"
    "${TEST_SOURCES}"
)


#----------------------------------------------------------------------------------
# Difficulty test
set(APP_LIB_NAME Difficulty)

# Add all the sources to the library
set(APP_SOURCES
    ${APP_DIR}/Configuration/Difficulty.cpp
)

set(APP_INCLUDES
    ${APP_DIR}/Configuration
)

set(APP_LINK_LIBS
    ""
)

set(TEST_SOURCES
    DifficultyTest.cpp
)

add_unit_test(
    ${APP_LIB_NAME}
    ${APP_DIR}
    "${APP_SOURCES}"
    "${APP_INCLUDES}"
    "${APP_LINK_LIBS}"
    "${TEST_SOURCES}"
)

#----------------------------------------------------------------------------------
# ConfigReader test
set(APP_LIB_NAME ConfigReader)

# Add all the sources to the library
set(APP_SOURCES
    ${APP_DIR}/Configuration/ConfigReader.cpp
    ${APP_DIR}/Configuration/Resolution.cpp
    ${APP_DIR}/Configuration/Difficulty.cpp
)

set(APP_INCLUDES
    ${APP_DIR}/Configuration
)

set(APP_LINK_LIBS
    ""
)

set(TEST_SOURCES
    ConfigReaderTest.cpp
)

add_unit_test(
    ${APP_LIB_NAME}
    ${APP_DIR}
    "${APP_SOURCES}"
    "${APP_INCLUDES}"
    "${APP_LINK_LIBS}"
    "${TEST_SOURCES}"
)
