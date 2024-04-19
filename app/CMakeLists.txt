cmake_minimum_required(VERSION 3.22)
project(my_project LANGUAGES CXX)

# C++17 Standard
set(CMAKE_CXX_STANDARD 17)

# Set the cmak module path
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Add source subdirectories
add_subdirectory(src)
add_subdirectory(thirdparty)

# include(Doxygen)
# Doxygen(src docs)

# Add test subdirectory
if (CMAKE_BUILD_TYPE STREQUAL Debug)
    add_subdirectory(test)
endif()
