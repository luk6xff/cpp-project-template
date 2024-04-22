# CppLint.cmake
cmake_minimum_required(VERSION 3.10)

# Find cpplint if not already found
find_program(CPPLINT_EXECUTABLE NAMES cpplint)
if(NOT CPPLINT_EXECUTABLE)
    message(FATAL_ERROR "cpplint not found! Please install cpplint or check your PATH.")
endif()

# Set the directory where the source files are located
set(CPPLINT_SOURCE_DIR ${CMAKE_SOURCE_DIR}/src)

# Define the output directory for cpplint reports
set(CPPLINT_REPORT_DIR ${CMAKE_BINARY_DIR}/cpplint_report)
set(CPPLINT_OUTPUT_FILE ${CPPLINT_REPORT_DIR}/report.txt)

# Find all relevant source files
file(GLOB_RECURSE ALL_SOURCE_FILES
     ${CPPLINT_SOURCE_DIR}/*.cpp
     ${CPPLINT_SOURCE_DIR}/*.h)

# Command to make directory for cpplint reports
add_custom_command(
    OUTPUT ${CPPLINT_REPORT_DIR}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CPPLINT_REPORT_DIR}
    COMMENT "Creating directory for cpplint reports"
    VERBATIM
)

# Create a custom command to run cpplint and capture its output
add_custom_command(
    OUTPUT ${CPPLINT_OUTPUT_FILE}
    COMMAND ${CPPLINT_EXECUTABLE} ${ALL_SOURCE_FILES} > ${CPPLINT_OUTPUT_FILE} 2>&1 || true
    DEPENDS ${CPPLINT_REPORT_DIR} ${ALL_SOURCE_FILES} # Ensure directory is created first and re-run cpplint if sources change
    COMMENT "Running cpplint"
    VERBATIM
)

# Create a custom target to run the custom commands
add_custom_target(
    cpplint
    DEPENDS ${CPPLINT_OUTPUT_FILE}
    COMMENT "cpplint report generated at: ${CPPLINT_OUTPUT_FILE}"
)

# Optionally add this analysis as a part of the project build
# add_dependencies(${PROJECT_NAME} cpplint)
