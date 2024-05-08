cmake_minimum_required(VERSION 3.22)
project(my_project LANGUAGES CXX)

# Set the prjocet default target
set(PROJECT_TARGET ${PROJECT_NAME})

# C++17 Standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Set the cmak module path
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Generate compile commands json file needed for static analyzers
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Add test subdirectory
if (UNIT_TESTS OR INTEGRATION_TESTS OR SYSTEM_TESTS)
    set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/test/bin)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX})
    # Debug always for tests
    set(CMAKE_BUILD_TYPE Debug)
    # Add source subdirectories
    add_subdirectory(test)
else()
    # Set Install prefix
    set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/bin)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX})
    # Add source subdirectories
    add_subdirectory(thirdparty)
    add_subdirectory(src)
    # Generate doxygen documentation
    include(Doxygen)
    Doxygen(${PROJECT_NAME} ${CMAKE_SOURCE_DIR}/src)

    if(${CMAKE_SYSTEM_PROCESSOR} MATCHES "x86_64")
        # CodeChecker
        include(CodeChecker)
    endif()

endif()
