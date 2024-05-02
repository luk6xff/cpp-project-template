################################################################################
# CMAKE Toolchain for Linux x86_64
#
# Specify toolchain file in cmake generation via:
# cmake -DCMAKE_TOOLCHAIN_FILE=Toolchain/Linux_x86_64.cmake -DCOMPILER_CHOICE=GCC -DDebug
#
# Author: Lukasz Uszko <lukasz.uszko@gmail.com>
################################################################################

include(CMakeForceCompiler)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
add_definitions("-DLINUX")
add_definitions("-D__linux__")
set(TOOLCHAIN "Linux x86_64")

# Compiler selection
set(COMPILER_CHOICE "GCC" CACHE STRING "Select the compiler: GCC or CLANG")
set_property(CACHE COMPILER_CHOICE PROPERTY STRINGS "GCC" "CLANG")

if (COMPILER_CHOICE STREQUAL "GCC")
    set(CMAKE_C_COMPILER /usr/bin/gcc)
    set(CMAKE_CXX_COMPILER /usr/bin/g++)
    # Define GCC-specific flags here
    set(COMPILER_SPECIFIC_FLAGS "-Wall -Wextra -pedantic -Werror -Wno-variadic-macros -Wshadow -Wformat-truncation -finline-functions")
elseif (COMPILER_CHOICE STREQUAL "CLANG")
    set(CMAKE_C_COMPILER /usr/bin/clang)
    set(CMAKE_CXX_COMPILER /usr/bin/clang++)
    # Define Clang-specific flags here
    set(COMPILER_SPECIFIC_FLAGS "-Wall -Wextra -Weverything -Werror -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-covered-switch-default -Wno-global-constructors -Wno-weak-vtables")
else()
    message(FATAL_ERROR "Invalid compiler choice: ${COMPILER_CHOICE}. Please select GCC or CLANG.")
endif()


# Debug and Release flags
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(COMPILER_SPECIFIC_FLAGS "${COMPILER_SPECIFIC_FLAGS} -O0 -g")
    if (COMPILER_CHOICE STREQUAL "GCC")
      set(COVERAGE_COMPILE_FLAGS "-fprofile-arcs -ftest-coverage")
      set(COVERAGE_LINK_FLAGS "-lgcov -fprofile-arcs -ftest-coverage")

    elseif(COMPILER_CHOICE STREQUAL "CLANG")
      set(COVERAGE_COMPILE_FLAGS "--coverage")
      set(COVERAGE_LINK_FLAGS "--coverage")
    endif()
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(COMPILER_SPECIFIC_FLAGS "${COMPILER_SPECIFIC_FLAGS} -O3")
endif()



# Combining all flags
set(FINAL_COMPILE_FLAGS "${COMPILER_SPECIFIC_FLAGS} ${COVERAGE_COMPILE_FLAGS}")
set(FINAL_LINK_FLAGS "${COVERAGE_LINK_FLAGS}")

set(CMAKE_CXX_FLAGS_INIT "${FINAL_COMPILE_FLAGS}")
set(CMAKE_C_FLAGS_INIT "${FINAL_COMPILE_FLAGS}")

# CMake configurations for security-hardened C/C++ builds
#set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# add_compile_options(-Wall -Wextra -Werror)
# add_compile_options(-D_FORTIFY_SOURCE=2)
# add_compile_options(-Wformat -Wformat-security)
# add_compile_options(-fstack-protector-strong)
# add_compile_options(-fwrapv -fno-strict-overflow -fno-delete-null-pointer-checks)

# add_link_options(-z relro -z now)
# add_link_options(-z noexecstack)
#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pie")


# Set the compiler flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_INIT}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${FINAL_LINK_FLAGS}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_INIT}")


# add_compile_options(${CMAKE_CXX_FLAGS_INIT})
# add_link_options("${CMAKE_EXE_LINKER_FLAGS} ${FINAL_LINK_FLAGS}")




# LU_TODO: Add support for coverage flags

# GCOV flags for gcc/g++
set(GCC_COVERAGE_COMPILE_FLAGS "-fprofile-arcs -ftest-coverage")
set(GCC_COVERAGE_LINK_FLAGS    "-lgcov -fprofile-arcs -ftest-coverage")

set(CMAKE_CXX_FLAGS_INIT "-O0 -g -Wno-variadic-macros -Wpedantic -Wshadow  -Wformat-truncation -finline-functions ${GCC_COVERAGE_COMPILE_FLAGS}") #  Wall -Wextra -Werror -Wfatal-errors -Wdouble-promotion)
set(CMAKE_C_FLAGS_INIT ${CMAKE_CXX_FLAGS_INIT})
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_INIT}")
set(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${GCC_COVERAGE_LINK_FLAGS}")
set(CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_INIT}")
