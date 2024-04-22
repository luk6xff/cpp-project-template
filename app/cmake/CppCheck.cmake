# cppcheck.cmake
cmake_minimum_required(VERSION 3.10)

# Find cppcheck and cppcheck-htmlreport script if not already found
find_program(CPPCHECK_EXECUTABLE NAMES cppcheck)
find_program(CPPCHECK_HTMLREPORT_EXECUTABLE NAMES cppcheck-htmlreport)

if(NOT CPPCHECK_EXECUTABLE)
    message(FATAL_ERROR "cppcheck not found! Please install cppcheck or check your PATH.")
endif()

if(NOT CPPCHECK_HTMLREPORT_EXECUTABLE)
    message(FATAL_ERROR "cppcheck-htmlreport not found! Please ensure it is installed and in your PATH.")
endif()

# Set the cppcheck working directory
set(CPPCHECK_WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/src)

# Set CPPCHECK_TEMPLATE to format the output messages
set(CPPCHECK_TEMPLATE "cppcheck:{file}:{line}: {severity}:{message}")

# Define the target directory for cppcheck reports
set(CPPCHECK_XML_OUTPUT_DIR ${CMAKE_BINARY_DIR}/cppcheck_xml_output)
set(CPPCHECK_HTML_REPORT_DIR ${CMAKE_BINARY_DIR}/cppcheck_html_report)

# Cppcheck output in XML format
set(CPPCHECK_XML_OUTPUT_FILE ${CPPCHECK_XML_OUTPUT_DIR}/report.xml)
# Cppcheck output in HTML format
set(CPPCHECK_HTML_OUTPUT_FILE ${CPPCHECK_HTML_REPORT_DIR}/index.html)

# Recursively find all header and source files in the specified directory
file(GLOB_RECURSE ALL_SOURCE_FILES ${CPPCHECK_WORKING_DIRECTORY}/*.cpp ${CPPCHECK_WORKING_DIRECTORY}/*.c ${CPPCHECK_WORKING_DIRECTORY}/*.h)

# Create a custom command to run cppcheck and generate XML output
add_custom_command(
    OUTPUT ${CPPCHECK_XML_OUTPUT_FILE}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CPPCHECK_XML_OUTPUT_DIR}
    COMMAND ${CPPCHECK_EXECUTABLE}
            --enable=all
            #--project=${CMAKE_BINARY_DIR}/compile_commands.json # LU_TODO: Use this option if you want to analyze thirdparty and _deps as well
            --xml-version=2
            --language=c++
            --std=c++17
            --template=${CPPCHECK_TEMPLATE}
            --output-file=${CPPCHECK_XML_OUTPUT_FILE}
            --quiet
            ${ALL_SOURCE_FILES}
    WORKING_DIRECTORY ${CPPCHECK_WORKING_DIRECTORY}
    COMMENT "Running cppcheck static analysis and generating XML output"
    VERBATIM
)

# Create a custom command to generate HTML report from XML output
add_custom_command(
    OUTPUT ${CPPCHECK_HTML_OUTPUT_FILE}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CPPCHECK_HTML_REPORT_DIR}
    COMMAND ${CPPCHECK_HTMLREPORT_EXECUTABLE}
            --file=${CPPCHECK_XML_OUTPUT_FILE}
            --report-dir=${CPPCHECK_HTML_REPORT_DIR}
            --source-dir=${CPPCHECK_WORKING_DIRECTORY}
    DEPENDS ${CPPCHECK_XML_OUTPUT_FILE}
    COMMENT "Generating HTML report from cppcheck XML output"
    VERBATIM
)

# Create a custom target to run the custom commands
add_custom_target(
    cppcheck
    DEPENDS ${CPPCHECK_HTML_OUTPUT_FILE}
    COMMENT "cppcheck HTML report is generated at: ${CPPCHECK_HTML_OUTPUT_FILE}"
)
