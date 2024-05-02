################################################################################
# CMAKE Toolchain for qnx aarch64le
#
# Prerequisite: qnx env has to be sourced before using.
# e.g.: source <qnx-sdp-path>/qnx710/qnxsdp-env.sh
# Specify toolchain file in cmake generation via
# cmake -D CMAKE_TOOLCHAIN_FILE=Toolchain/Qnx_aarch64le.cmake -D OTHER_FLAGS ..
#
# Author: Lukasz Uszko <lukasz.uszko@gmail.com>
################################################################################

# Force compiler
include(CMakeForceCompiler)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

# OS and processor target
set(CMAKE_SYSTEM_NAME QNX)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(TOOLCHAIN QNX)

# Add some useful definitions to the compiler
add_definitions(-DQNX)
set(BUILDING_FOR_QNX_AARCH64 1)


# Set compiler arch
set(arch gcc_ntoaarch64le)

# QNX specific flags
set(ntoarch aarch64)
set(QNX_PROCESSOR aarch64)
set(TARGET_ARCH "aarch64le")
set(TARGET_ARCH_TYPE "armv8.2-a")

# Compiler settings
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

set(CMAKE_C_COMPILER $ENV{QNX_HOST}/usr/bin/nto${ntoarch}-gcc)
set(CMAKE_CXX_COMPILER $ENV{QNX_HOST}/usr/bin/nto${ntoarch}-g++)
set(CMAKE_C_COMPILER_TARGET ${arch})
set(CMAKE_CXX_COMPILER_TARGET ${arch})
set(CMAKE_RANLIB $ENV{QNX_HOST}/usr/bin/nto${ntoarch}-ranlib CACHE PATH "QNX ranlib Program" FORCE)
set(CMAKE_AR $ENV{QNX_HOST}/usr/bin/nto${ntoarch}-ar CACHE PATH "QNX ar Program" FORCE)
set(CMAKE_ASM_COMPILER $ENV{QNX_HOST}/usr/bin/nto${ntoarch}-as CACHE PATH "QNX as Program" FORCE)
set(CMAKE_ASM_DEFINE_FLAG "-Wa,--defsym,")

set(CMAKE_SYSROOT $ENV{QNX_TARGET})
message(STATUS "CMAKE_SYSROOT: ${CMAKE_SYSROOT}")

# Setting QNX compiler flags
set(QNX_FLAGS "-Werror -Wall -Wextra -Wno-variadic-macros -Wfatal-errors -Wpedantic -Wshadow -Wdouble-promotion -Wformat-truncation -finline-functions -march=${TARGET_ARCH_TYPE}")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(QNX_FLAGS "${QNX_FLAGS} -O0 -g")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
  set(QNX_FLAGS "${QNX_FLAGS} -O3")
endif()

set(CMAKE_CXX_FLAGS_INIT "${QNX_FLAGS}")
set(CMAKE_C_FLAGS_INIT "${QNX_FLAGS}")

# Set the target directories
set(CMAKE_FIND_ROOT_PATH "$ENV{QNX_TARGET}/${TARGET_ARCH}")
message(STATUS "CMAKE_FIND_ROOT_PATH: ${CMAKE_FIND_ROOT_PATH}")

# Where is the target environment located
set(CMAKE_FIND_ROOT_PATH  ${PROJECT_SOURCE_DIR})

# Search for programs in the build host directories.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# Search for libraries and headers in the target directories.
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
