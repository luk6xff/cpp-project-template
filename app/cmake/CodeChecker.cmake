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

# Configure CodeChecker server settings
set(CODECHECKER_SERVER_PORT 8999)
set(CODECHECKER_SERVER_URL http://localhost:${CODECHECKER_SERVER_PORT}/Default)

# Command to clean previous reports
add_custom_command(
    OUTPUT ${CODECHECKER_REPORT_DIR}_clean
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CODECHECKER_REPORT_DIR}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CODECHECKER_REPORT_DIR}
    COMMENT "Cleaning previous CodeChecker outputs"
    VERBATIM
)

# Custom targets for each analysis tool
# add_custom_target(run_cppcheck
#     #COMMAND cppcheck --enable=all --xml-version=2 ${CMAKE_SOURCE_DIR} 2> ${CMAKE_BINARY_DIR}/cppcheck_results.xml
#     COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t cppcheck -o ${CODECHECKER_REPORT_DIR}/cppcheck ${CMAKE_BINARY_DIR}/cppcheck_report/
#     DEPENDS cppcheck ${CODECHECKER_REPORT_DIR}_clean
#     COMMENT "Running cppcheck and converting results"
# )

add_custom_target(run_cpplint
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CODECHECKER_REPORT_DIR}/cpplint
    COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t cpplint -o ${CODECHECKER_REPORT_DIR}/cpplint ${CMAKE_BINARY_DIR}/cpplint_report
    COMMAND ${CODECHECKER_EXECUTABLE} parse --export html --output ${CODECHECKER_REPORT_DIR}/cpplint ${CODECHECKER_REPORT_DIR}/cpplint || true
    DEPENDS cpplint
    COMMENT "Processing and converting cpplint report to CodeChecker format..."
)

add_custom_target(run_clang_tidy
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CODECHECKER_REPORT_DIR}/clang_tidy
    COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t clang-tidy -o ${CODECHECKER_REPORT_DIR}/clang_tidy ${CMAKE_BINARY_DIR}/clang_tidy_report
    COMMAND ${CODECHECKER_EXECUTABLE} parse --export html --output ${CODECHECKER_REPORT_DIR}/clang_tidy ${CODECHECKER_REPORT_DIR}/clang_tidy || true
    DEPENDS clang_tidy
    COMMENT "Processing and converting clang-tidy report to CodeChecker format..."
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
    #COMMAND ${CODECHECKER_EXECUTABLE} server --workspace ${CODECHECKER_REPORT_DIR} --not-host-only --port ${CODECHECKER_SERVER_PORT} &
    COMMAND sh -c "${CODECHECKER_EXECUTABLE} server --workspace ${CODECHECKER_REPORT_DIR} --not-host-only --port ${CODECHECKER_SERVER_PORT} &"
    # Give it a moment to ensure the server is up before attempting to store the results
    COMMAND sleep 1
    COMMAND ${CODECHECKER_EXECUTABLE} store ${CODECHECKER_REPORT_DIR} --name "${PROJECT_NAME} Static Analysis Results" --url ${CODECHECKER_SERVER_URL}
    DEPENDS run_cpplint run_clang_tidy #run_cppcheck   #run_infer
    COMMENT "CodeChecker analysis and server starting at: ${CODECHECKER_SERVER_URL}"
    VERBATIM
)

add_custom_target(
    codechecker_update
    COMMAND ${CMAKE_COMMAND} -E echo "Updating CodeChecker Database with the reports"
    #DEPENDS codechecker
    COMMAND ${CODECHECKER_EXECUTABLE} store ${CODECHECKER_REPORT_DIR} --name "${PROJECT_NAME} Static Analysis Results" --url ${CODECHECKER_SERVER_URL}
    COMMENT "CodeChecker analysis and server starting at: ${CODECHECKER_SERVER_URL}"
    VERBATIM
)

# Ensure that CodeChecker analysis runs as part of the build (optional)
# add_dependencies(${PROJECT_NAME} codechecker_analyze)
