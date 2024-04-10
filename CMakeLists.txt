################################################################################
#
# @copyright (c) 2023 Aptiv
#
# @brief Cmake build system for MPIC project
#
# @version 1.1
# @author Lukasz Uszko <lukasz.uszko@aptiv.com>
#
################################################################################

# Set Cmake minimum supported version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# Set Project Name
set(CMAKE_PROJECT_NAME mpic-camdriver)

# Set installing PREFIX
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/output)

# Set the language standards
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 11)

# Supported targets in mpic project
set(MPIC_PROJECT_TARGETS_LIST "Civic" "TigerBox")

# KPI Markers option
option(KPI_MARKERS "Enable KPI Markers feature" ON)

# Set the build type
set(CMAKE_BUILD_TYPE Release)
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
    "Choose the type of MPIC_CAMDRIVER_APP build, options are: Debug Release."
    FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# Apply options only for Civic
set(CIVIC_PRODUCT_LINES "i3" "i3star3")
if (PRODUCT_LINE IN_LIST CIVIC_PRODUCT_LINES)
    set(MPIC_PROJECT_TARGET Civic)
    add_definitions(-DQNX)
endif()

# Create project if target is valid
if (MPIC_PROJECT_TARGET IN_LIST MPIC_PROJECT_TARGETS_LIST)
    # Set the project name
    project(
        mpic-camdriver
        VERSION 1.0
        LANGUAGES CXX C
    )
    # Skip libs and unresolved symbols for coverity
    if (COVERITY_BUILD)
        set(COVERITY_LINKER_FLAGS "-Wl,--unresolved-symbols=ignore-all")
        set(CMAKE_EXE_LINKER_FLAGS ${COVERITY_LINKER_FLAGS})
        message(STATUS ">>> APP BUILD FOR COVERITY STARTED, UNRESOLVED SYMBOLS WILL BE IGNORED <<<")
    endif()

    if (MPIC_CAMDRIVER_INTEGRATION_TESTS)
        add_definitions(-DMPIC_CAMDRIVER_INTEGRATION_TESTS)
    endif()

    add_definitions(-D${MPIC_PROJECT_TARGET})
    add_definitions(-DAPTIV_BUILD)
    add_subdirectory(${MPIC_PROJECT_TARGET})
else()
    message(FATAL_ERROR "MPIC_PROJECT_TARGET is not set! Please set it using -DMPIC_PROJECT_TARGET=<value>")
endif()
