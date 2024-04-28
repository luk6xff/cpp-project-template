cmake_minimum_required(VERSION 3.22)
project(my_project LANGUAGES CXX)

# Set the prjocet default target
set(PROJECT_TARGET ${PROJECT_NAME})

# C++17 Standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set the build type - LU_TODO: - Move this to the command line
set(CMAKE_BUILD_TYPE Debug)

# Set binary output directory and install prefix
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX})

# Set the cmak module path
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Generate compile commands json file needed for CodeChecker and static analyzers
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Add test subdirectory
if (UNIT_TESTS)
    add_subdirectory(test)
else()
    # Add source subdirectories
    add_subdirectory(thirdparty)
    add_subdirectory(src)

    # Generate doxygen documentation
    include(Doxygen)
    Doxygen(${PROJECT_NAME} ${CMAKE_SOURCE_DIR}/src)

    # CodeChecker
    include(CodeChecker)
endif()
