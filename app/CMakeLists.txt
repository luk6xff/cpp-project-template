cmake_minimum_required(VERSION 3.22)
project(my_project LANGUAGES CXX)

# Set the prjocet default target
set(PROJECT_TARGET ${PROJECT_NAME})

# C++17 Standard
set(CMAKE_CXX_STANDARD 17)

# Set binary output directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Set the cmak module path
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Add source subdirectories
add_subdirectory(thirdparty)
add_subdirectory(src)

include(Doxygen)
Doxygen(src docs)

# Add test subdirectory
# if (CMAKE_BUILD_TYPE STREQUAL Debug)
#     add_subdirectory(test)
# endif()
