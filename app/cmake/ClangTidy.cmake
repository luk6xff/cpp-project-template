# ClangTidy.cmake
cmake_minimum_required(VERSION 3.10)

find_program(CLANG_TIDY_EXECUTABLE NAMES clang-tidy)
if(NOT CLANG_TIDY_EXECUTABLE)
    message(FATAL_ERROR "clang-tidy not found! Please install clang-tidy or check your PATH.")
endif()

set(CLANG_TIDY_SOURCE_DIR ${CMAKE_SOURCE_DIR}/src)
file(GLOB_RECURSE ALL_SOURCE_FILES
     ${CLANG_TIDY_SOURCE_DIR}/*.cpp
     ${CLANG_TIDY_SOURCE_DIR}/*.h)

# Define the target directory for clang-tidy reports
set(CLANG_TIDY_REPORT_OUTPUT_DIR ${CMAKE_BINARY_DIR}/clang_tidy_report)
set(CLANG_TIDY_OUTPUT_FILE ${CLANG_TIDY_REPORT_OUTPUT_DIR}/report.txt)

add_custom_command(
    OUTPUT ${CLANG_TIDY_OUTPUT_FILE}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CLANG_TIDY_REPORT_OUTPUT_DIR}
    COMMAND ${CLANG_TIDY_EXECUTABLE}
            -p ${CMAKE_BINARY_DIR}
            ${ALL_SOURCE_FILES}
            > ${CLANG_TIDY_OUTPUT_FILE} 2>&1
            || true  # Ignore clang-tidy exit status
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Running clang-tidy and saving output to file"
    VERBATIM
)

add_custom_target(
    clang_tidy
    DEPENDS ${CLANG_TIDY_OUTPUT_FILE}
    COMMENT "clang-tidy output saved to ${CLANG_TIDY_OUTPUT_FILE}"
)

# Optionally add this analysis as part of the project build
# add_dependencies(${PROJECT_NAME} clang_tidy)
