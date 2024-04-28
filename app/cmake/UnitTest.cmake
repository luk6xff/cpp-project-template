#! make_test : Creates and adds a test to the CMake CTEST pipeline.
#
# This function performs two main actions:
# 1. Creates a library from the provided application component sources.
# 2. Constructs a test executable that links with the above-created library.
#
# Additional support is provided for 'Stubs' and 'Mocks':
# - 'Stubs' directory should be placed in the test directory and is included in the app library.
# - 'Mock' directory should also be placed in the test directory and is included in the test executable.
# The final executable is then registered with the CMake CTEST pipeline.
#
# \arg:APP_LIB_NAME Name of the application library to be created.
# \arg:APP_DIR Path to the application component directory.
# \arg:APP_SOURCES List of application source files ('*.cpp').
# \arg:APP_INCLUDES List of directories to be included in the application library.
# \arg:APP_LINK_LIBS List of libraries to link with the application library.
# \arg:TEST_SOURCES List of test source files ('*.cpp').
#
function(make_test APP_LIB_NAME APP_DIR APP_SOURCES APP_INCLUDES APP_LINK_LIBS TEST_SOURCES)
    project(${APP_LIB_NAME}Test)

    # Declare and create the library
    add_library(${APP_LIB_NAME} STATIC ${APP_SOURCES})
    target_include_directories(${APP_LIB_NAME} PUBLIC ${APP_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/Stubs ${APP_INCLUDES})
    target_link_libraries(${APP_LIB_NAME} PUBLIC ${APP_LINK_LIBS})
    target_compile_options(${APP_LIB_NAME} PRIVATE -fsanitize=address -fsanitize=undefined)
    target_link_libraries(${APP_LIB_NAME} PRIVATE -fsanitize=address -fsanitize=undefined)

    # Set the name for the test executable
    set(BINARY ${PROJECT_NAME})

    # Create the test executable
    add_executable(${BINARY} ${TEST_SOURCES})
    target_include_directories(${BINARY} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Mock ${CMAKE_CURRENT_BINARY_DIR})
    target_link_libraries(${BINARY} PUBLIC gmock_main ${APP_LIB_NAME})

    # Register the test with CMake CTEST
    add_test(NAME ${BINARY} COMMAND ${BINARY} --gtest_output=xml:${BINARY}.xml)
endfunction()


#! make_test_binary : Creates and adds a test binary to the CMake CTEST pipeline.
#
# This function creates a test executable linked with specified libraries and registers it with the CTest pipeline.
# If needed, create a 'Mock' directory in the test directory which will be included in the test binary.
#
# \arg:BINARY_NAME Name of the test binary to be created.
# \arg:LIBS_TO_LINK List of libraries to link with the test binary.
# \arg:DIRS_TO_INC List of include directories for the test binary.
# \arg:TEST_SOURCES List of test source files ('*.cpp').
#
function(make_test_binary BINARY_NAME LIBS_TO_LINK DIRS_TO_INC TEST_SOURCES)
    project(${BINARY_NAME}Test)

    # Set the binary name for the test executable
    set(BINARY ${BINARY_NAME}Test)

    # Create the test executable
    add_executable(${BINARY} ${TEST_SOURCES})
    target_include_directories(${BINARY} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Mock ${CMAKE_CURRENT_BINARY_DIR} ${DIRS_TO_INC})
    target_link_libraries(${BINARY} PUBLIC gmock_main ${LIBS_TO_LINK})

    # include(Coverage)
    # AddCoverage(${BINARY})
    include(Testing)
    AddTests(${BINARY})
    EnableCoverage(${BINARY})

    # Register the test with CMake CTest
    add_test(NAME ${BINARY} COMMAND ${BINARY} --gtest_output=xml:${BINARY}.xml)
    include(GoogleTest)
    gtest_discover_tests(${BINARY})
endfunction()
