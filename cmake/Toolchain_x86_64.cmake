################################################################################
# CMAKE Toolchain for linux x86_64
#
#
# Specify toolchain file in cmake generation via
# cmake -D CMAKE_TOOLCHAIN_FILE=Toolchain_x86_64.cmake -D OTHER_FLAGS ..
#
# Author: Lukasz Uszko <lukasz.uszko@gmail.com>
################################################################################

# Force compiler
include(CMakeForceCompiler)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

# OS and processor target
set(CMAKE_SYSTEM_NAME Linux)
add_definitions("-DLINUX")
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# Specify the cross compiler
set(CMAKE_C_COMPILER   /usr/bin/gcc)
set(CMAKE_CXX_COMPILER /usr/bin/g++)

# Where is the target environment
set(CMAKE_FIND_ROOT_PATH  ${PROJECT_SOURCE_DIR})

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Specifies default compiler flags for the project

# GCOV flags for gcc/g++
set(GCC_COVERAGE_COMPILE_FLAGS "-fprofile-arcs -ftest-coverage")
set(GCC_COVERAGE_LINK_FLAGS    "-lgcov -fprofile-arcs -ftest-coverage")

set(CMAKE_CXX_FLAGS_INIT "-O0 -g -Werror -Wall -Wextra -Wno-variadic-macros -Wfatal-errors -Wpedantic -Wshadow -Wdouble-promotion -Wformat-truncation -finline-functions ${GCC_COVERAGE_COMPILE_FLAGS}")
set(CMAKE_C_FLAGS_INIT ${CMAKE_CXX_FLAGS_INIT})
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_INIT}")
set(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${GCC_COVERAGE_LINK_FLAGS}")
set(CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_INIT}")
