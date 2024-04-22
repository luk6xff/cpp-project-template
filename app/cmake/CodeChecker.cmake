# CodeChecker.cmake
cmake_minimum_required(VERSION 3.10)

# Find CodeChecker executable
find_program(CODECHECKER_EXECUTABLE NAMES CodeChecker)
if(NOT CODECHECKER_EXECUTABLE)
    message(FATAL_ERROR "CodeChecker not found! Please install CodeChecker or check your PATH.")
endif()

# Find report-converter executable
find_program(REPORT_CONVERTER_EXECUTABLE NAMES report-converter
            PATHS /opt/CodeChecker/build/CodeChecker/bin
            NO_DEFAULT_PATH)
if(NOT REPORT_CONVERTER_EXECUTABLE)
    message(FATAL_ERROR "report-converter not found! Please check your installation.")
endif()

# Set the directory to store CodeChecker reports
set(CODECHECKER_REPORT_DIR ${CMAKE_BINARY_DIR}/codechecker_report)

# Command to clean previous reports
add_custom_command(
    OUTPUT ${CODECHECKER_REPORT_DIR}_clean
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CODECHECKER_REPORT_DIR}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CODECHECKER_REPORT_DIR}
    COMMENT "Cleaning previous CodeChecker outputs"
    VERBATIM
)

# Custom targets for each analysis tool
add_custom_target(run_cppcheck
    #COMMAND cppcheck --enable=all --xml-version=2 ${CMAKE_SOURCE_DIR} 2> ${CMAKE_BINARY_DIR}/cppcheck_results.xml
    COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t cppcheck -o ${CODECHECKER_REPORT_DIR}/cppcheck ${CMAKE_BINARY_DIR}/cppcheck_report/report.xml
    COMMENT "Running cppcheck and converting results"
)

add_custom_target(run_cpplint
    #COMMAND cpplint --recursive ${CMAKE_SOURCE_DIR}/* > ${CMAKE_BINARY_DIR}/cpplint_results.txt
    COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t cpplint -o ${CODECHECKER_REPORT_DIR}/cpplint ${CMAKE_BINARY_DIR}/cpplint_report/report.txt
    COMMENT "Running cpplint and converting results"
)

add_custom_target(run_clang_tidy
    #COMMAND run-clang-tidy.py -header-filter='.*' -checks='-*,clang-analyzer-*' -export-fixes=${CMAKE_BINARY_DIR}/clang_tidy_fixes.yaml ${CMAKE_SOURCE_DIR}
    COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t clang-tidy -o ${CODECHECKER_REPORT_DIR}/clang_tidy ${CMAKE_BINARY_DIR}/clang-tidy-report.txt
    COMMENT "Running clang-tidy and converting results"
)

# add_custom_target(run_infer
#     #COMMAND infer run -- clang++ -c ${CMAKE_SOURCE_DIR}/*.cpp -I ${CMAKE_SOURCE_DIR}
#     COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t fbinfer -o ${CODECHECKER_REPORT_DIR}/infer ${CMAKE_BINARY_DIR}/infer-out
#     COMMENT "Running infer and converting results"
# )

# Custom target to run CodeChecker with configured tools
add_custom_target(
    codechecker
    COMMAND ${CMAKE_COMMAND} -E echo "Running static analysis tools with CodeChecker..."
    #COMMAND ${CODECHECKER_EXECUTABLE} analyze ${CMAKE_BINARY_DIR}/compile_commands.json --output ${CODECHECKER_REPORT_DIR} --enable all
    DEPENDS ${CODECHECKER_REPORT_DIR}_clean run_cppcheck run_cpplint run_clang_tidy #run_infer
    #COMMAND ${CODECHECKER_EXECUTABLE} web --start-server --workspace ${CODECHECKER_REPORT_DIR}
    COMMAND ${CODECHECKER_EXECUTABLE} server --workspace ${CODECHECKER_REPORT_DIR} --not-host-only
    COMMENT "CodeChecker analysis and server starting..."
    VERBATIM
)

# Ensure that CodeChecker analysis runs as part of the build (optional)
# add_dependencies(${PROJECT_NAME} codechecker_analyze)
