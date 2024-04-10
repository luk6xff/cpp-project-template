
#! make_test : Make and add test to Cmake CTEST pipeline
#
# In the first step, this function creates a library from the app component
# sources. In the second step, it creates a test binary with the linked
# above library.
#
# Func provides helpers for Stubs and Mocks, just create
# the 'Mock' and 'Stubs' directories in the test directory if you need to.
# The 'Stubs' directory will be included to the app library, and
# the 'Mock' directory will be included to the test binary.
# Finally, the binary created will be added to Cmake CTEST pipeline
#
# \arg:APP_COMPONENT_LIB_NAME name of the app library that will be created
# \arg:APP_COMPONENT_DIR path to the app component directory
# \arg:APP_COMPONENT_SOURCES list of app sources ('*.cpp')
# \arg:APP_COMPONENT_INC_DIRS_EXTERNAL_COMPONENTS list of directories that will be included in the app library
# \arg:APP_COMPONENT_LINK_LIBS list of directories that will be linked to the app library
# \arg:TEST_SOURCES list of test sources ('*cpp')
#
function(make_test APP_COMPONENT_LIB_NAME APP_COMPONENT_DIR APP_COMPONENT_SOURCES APP_COMPONENT_INC_DIRS_EXTERNAL_COMPONENTS APP_COMPONENT_LINK_LIBS TEST_SOURCES)
    project(${APP_COMPONENT_LIB_NAME}_test)

    #---------------------------------------------------
    # Declare the library

    add_library(
        ${APP_COMPONENT_LIB_NAME}
        STATIC
        ${APP_COMPONENT_SOURCES}
    )

    target_include_directories(
        ${APP_COMPONENT_LIB_NAME}
        PUBLIC
        ${APP_COMPONENT_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/Stubs
        ${APP_COMPONENT_INC_DIRS_EXTERNAL_COMPONENTS}
    )

    target_link_libraries(
        ${APP_COMPONENT_LIB_NAME}
        PUBLIC
        ${APP_COMPONENT_LINK_LIBS}
    )

    target_compile_options(${APP_COMPONENT_LIB_NAME} PRIVATE -fsanitize=address -fsanitize=undefined)
    target_link_libraries(${APP_COMPONENT_LIB_NAME} PRIVATE -fsanitize=address -fsanitize=undefined)

    #---------------------------------------------------
    # Add an tested app directory

    # Set the binary name
    set(BINARY ${PROJECT_NAME})

    # Unit test binary
    add_executable(
        ${BINARY}
        ${TEST_SOURCES}
    )

    target_include_directories(
        ${BINARY}
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/Mock
        ${CMAKE_CURRENT_BINARY_DIR}
    )

    target_link_libraries(
        ${BINARY}
        PUBLIC
        gmock_main
        ${APP_COMPONENT_LIB_NAME}
    )

    # Finally add the test to Cmake CTEST pipeline
    add_test(NAME ${BINARY} COMMAND ${BINARY} --gtest_output=xml:${BINARY}.xml)
endfunction()

#! make_test_binary : Make and add test to Cmake CTEST pipeline
#
# Create a test binary and add it to Cmake CTEST pipeline
#
# Func provides helper for Mocks, just create the 'Mock' directory in the test
# directory if you need to. The 'Mock' directory will be included to the test
# binary. Finally, the binary created will be added to Cmake CTEST pipeline
#
# \arg:BINARY_NAME name of the test binary that will be created
# \arg:LIBS_TO_LINK list of libraries to link with the test binary
# \arg:DIRS_TO_INC list of directories to include in the test binary
# \arg:TEST_SOURCES list of test sources ('*cpp')
#
function(make_test_binary BINARY_NAME LIBS_TO_LINK DIRS_TO_INC TEST_SOURCES)
    project(${BINARY_NAME}_test)

    # Add an tested app directory

    # Set the binary name
    set(BINARY ${PROJECT_NAME})

    # Unit test binary
    add_executable(
        ${BINARY}
        ${TEST_SOURCES}
    )

    target_include_directories(
        ${BINARY}
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/Mock
        ${CMAKE_CURRENT_BINARY_DIR}
        ${DIRS_TO_INC}
    )

    target_link_libraries(
        ${BINARY}
        PUBLIC
        gmock_main
        ${LIBS_TO_LINK}
    )

    # Finally add the test to Cmake CTEST pipeline
    add_test(NAME ${BINARY} COMMAND ${BINARY} --gtest_output=xml:${BINARY}.xml)
endfunction()
