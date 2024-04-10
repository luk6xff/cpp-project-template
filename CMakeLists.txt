################################################################################
#
# @copyright (c) 2023 luk6xff
#
# @brief Cmake build system for luk6xff's project
#
# @version 1.1
# @author Lukasz Uszko <lukasz.uszko@gmail.com>
#
################################################################################

# Set Cmake minimum supported version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# Set Project Name
set(CMAKE_PROJECT_NAME my_project)

# Set installing PREFIX
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/output)

# Set the language standards
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 11)

# Supported targets in the project
set(PROJECT_TARGETS_LIST "App")

# KPI Markers option
option(KPI_MARKERS "Enable KPI Markers feature" ON)

# Set the build type
set(CMAKE_BUILD_TYPE Release)
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
    "Choose the type of the project build, options are: Debug Release."
    FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# Apply options only for QNX
set(PRODUCT_LINES "qnx")
if (PRODUCT_LINE IN_LIST PRODUCT_LINES)
    set(PROJECT_TARGET QnxApp)
    add_definitions(-DQNX)
endif()

# Create project if target is valid
if (PROJECT_TARGET IN_LIST PROJECT_TARGETS_LIST)
    # Set the project name
    project(
        ${CMAKE_PROJECT_NAME}
        VERSION 1.0
        LANGUAGES CXX C
    )
    # Skip libs and unresolved symbols for coverity
    if (COVERITY_BUILD)
        set(COVERITY_LINKER_FLAGS "-Wl,--unresolved-symbols=ignore-all")
        set(CMAKE_EXE_LINKER_FLAGS ${COVERITY_LINKER_FLAGS})
        message(STATUS ">>> APP BUILD FOR COVERITY STARTED, UNRESOLVED SYMBOLS WILL BE IGNORED <<<")
    endif()

    if (PROJECT_INTEGRATION_TESTS)
        add_definitions(-DPROJECT_INTEGRATION_TESTS)
    endif()

    add_definitions(-D${PROJECT_TARGET})
    add_subdirectory(${PROJECT_TARGET})
else()
    message(FATAL_ERROR "PROJECT_TARGET is not set! Please set it using -DPROJECT_TARGET=<value>")
endif()
