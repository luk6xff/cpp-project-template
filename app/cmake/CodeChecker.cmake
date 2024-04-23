# CodeChecker.cmake
cmake_minimum_required(VERSION 3.10)

# Include the necessary modules
include(CppCheck)
include(ClangTidy)
include(Infer)
include(CppLint)

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
add_custom_target(process_report_cppcheck
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CODECHECKER_REPORT_DIR}/cppcheck
    COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t cppcheck -o ${CODECHECKER_REPORT_DIR}/cppcheck ${CMAKE_BINARY_DIR}/cppcheck_report || true
    COMMAND ${CODECHECKER_EXECUTABLE} parse --export html --output ${CODECHECKER_REPORT_DIR}/cppcheck ${CODECHECKER_REPORT_DIR}/cppcheck || true
    DEPENDS cppcheck
    COMMENT "Processing and converting cpplint report to CodeChecker format..."
)


add_custom_target(process_report_cpplint
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CODECHECKER_REPORT_DIR}/cpplint
    COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t cpplint -o ${CODECHECKER_REPORT_DIR}/cpplint ${CMAKE_BINARY_DIR}/cpplint_report || true
    COMMAND ${CODECHECKER_EXECUTABLE} parse --export html --output ${CODECHECKER_REPORT_DIR}/cpplint ${CODECHECKER_REPORT_DIR}/cpplint || true
    DEPENDS cpplint
    COMMENT "Processing and converting cpplint report to CodeChecker format..."
)

add_custom_target(process_report_clang_tidy
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CODECHECKER_REPORT_DIR}/clang_tidy
    COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t clang-tidy -o ${CODECHECKER_REPORT_DIR}/clang_tidy ${CMAKE_BINARY_DIR}/clang_tidy_report || true
    COMMAND ${CODECHECKER_EXECUTABLE} parse --export html --output ${CODECHECKER_REPORT_DIR}/clang_tidy ${CODECHECKER_REPORT_DIR}/clang_tidy || true
    DEPENDS clang_tidy
    COMMENT "Processing and converting clang-tidy report to CodeChecker format..."
)

add_custom_target(process_report_infer
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CODECHECKER_REPORT_DIR}/infer
    COMMAND ${REPORT_CONVERTER_EXECUTABLE} -t fbinfer -o ${CODECHECKER_REPORT_DIR}/infer ${CMAKE_BINARY_DIR}/infer-out/report.json || true
    COMMAND ${CODECHECKER_EXECUTABLE} parse --export html --output ${CODECHECKER_REPORT_DIR}/infer ${CODECHECKER_REPORT_DIR}/infer || true
    DEPENDS infer
    COMMENT "Processing and converting infer report to CodeChecker format..."
)

# Custom target to run CodeChecker with configured tools
add_custom_target(
    codechecker
    COMMAND ${CMAKE_COMMAND} -E echo "Running static analysis tools with CodeChecker..."
    #COMMAND ${CODECHECKER_EXECUTABLE} analyze ${CMAKE_BINARY_DIR}/compile_commands.json --output ${CODECHECKER_REPORT_DIR} --enable all
    COMMAND sh -c "${CODECHECKER_EXECUTABLE} server --workspace ${CODECHECKER_REPORT_DIR} --not-host-only --port ${CODECHECKER_SERVER_PORT} &"
    # Give it a moment to ensure the server is up before attempting to store the results
    COMMAND sleep 1
    COMMAND ${CODECHECKER_EXECUTABLE} store ${CODECHECKER_REPORT_DIR} --name "Static Analysis Results for the project: ${PROJECT_NAME}" --url ${CODECHECKER_SERVER_URL}
    DEPENDS process_report_cpplint
            process_report_clang_tidy
            process_report_cppcheck
            process_report_infer
    COMMENT "CodeChecker analysis and server starting at: ${CODECHECKER_SERVER_URL}"
    VERBATIM
)
