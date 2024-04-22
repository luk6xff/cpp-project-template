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

set(CLANG_TIDY_OUTPUT_FILE ${CMAKE_BINARY_DIR}/clang-tidy-report.txt)

add_custom_command(
    OUTPUT ${CLANG_TIDY_OUTPUT_FILE}
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
