# Creates and adds a unit test to the CMake CTest pipeline.
#
# This function performs two main actions:
# 1. It creates a library from the specified application component sources.
# 2. It constructs a test executable that links with the created library.
#
# Additional support for 'Stubs' and 'Mocks':
# - The 'Stubs' directory should be placed in the test directory and is included in the app library.
# - The 'Mock' directory should also be placed in the test directory and is included in the test executable.
#
# The final test executable is then registered with the CMake CTest framework.
#
# Arguments:
#   APP_LIB_NAME - The name to assign to the target library created.
#   APP_DIR - Directory path that contains the application components.
#   APP_SOURCES - List of source files for the application library.
#   APP_INCLUDES - Directories to include in the application library target.
#   APP_LINK_LIBS - Libraries to link against the application library. It should be formatted as a CMake list.
#   TEST_SOURCES - Source files that contain the test cases.
#
# Details:
#   ENABLE_SANITIZERS - A CMake option that allows enabling address and undefined behavior sanitizers
#   for this target (default OFF). When enabled, it applies -fsanitize=address and -fsanitize=undefined
#   to the compile and link options of the target.
#
# Examples:
#   add_unit_test(
#     APP_LIB_NAME ConfigReader
#     APP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src/ConfigReader"
#     APP_SOURCES "ConfigReader.cpp" "Utility.cpp"
#     APP_INCLUDES "${CMAKE_CURRENT_SOURCE_DIR}/include"
#     APP_LINK_LIBS "Utils;Crypto"
#     TEST_SOURCES "ConfigReaderTest.cpp"
#   )
#
function(add_unit_test APP_LIB_NAME APP_DIR APP_SOURCES APP_INCLUDES APP_LINK_LIBS TEST_SOURCES)

    # Create the library target
    add_library(${APP_LIB_NAME} STATIC ${APP_SOURCES})
    target_include_directories(${APP_LIB_NAME} PUBLIC ${APP_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/Stubs ${APP_INCLUDES})

    if(NOT "${APP_LINK_LIBS}" STREQUAL "")
        target_link_libraries(${APP_LIB_NAME} PUBLIC ${APP_LINK_LIBS})
    endif()

    # Set the name for the test executable
    set(TEST_BINARY ${APP_LIB_NAME}Test)

    # Create the test executable
    add_executable(${TEST_BINARY} ${TEST_SOURCES})
    target_include_directories(${TEST_BINARY}
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/Mock
        ${CMAKE_CURRENT_BINARY_DIR}
    )
    target_link_libraries(${TEST_BINARY}
        PUBLIC
        gtest
        gmock
        gtest_main
        ${APP_LIB_NAME}
    )

    # Enable Coverage
    include(Coverage)
    AddCoverage(${TEST_BINARY})

    # Register the test with CMake CTest
    gtest_discover_tests(${TEST_BINARY}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        XML_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}
    )

    # Memcheck
    include(Memcheck)
    AddMemcheck(${TEST_BINARY})

    # Valgrind
    include(Valgrind)
    AddValgrind(${TEST_BINARY})

    # Enable sanitizers
    include(Sanitizers)
    option(ASAN "Enable AddressSanitizer" OFF)
    option(TSAN "Enable ThreadSanitizer" OFF)
    option(UBSAN "Enable UndefinedBehaviorSanitizer" ON)
    option(MSAN "Enable MemorySanitizer" OFF)
    enable_sanitizers(${TEST_BINARY})

endfunction()
