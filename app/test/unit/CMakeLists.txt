project(unit_tests LANGUAGES CXX)


# Include GoogleTest fetched in the main CMakeLists.txt
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
)
FetchContent_MakeAvailable(googletest)

# Set variables
set(APP_DIR ${CMAKE_SOURCE_DIR}/src)
set(UNIT_TESTS_BINARY_DIR ${CMAKE_BINARY_DIR}/test/unit)
set(UNIT_TESTS_REPORT_DIR ${CMAKE_BINARY_DIR}/test/unit/report)

# Enable testing with CTest
enable_testing()

# Include packages
include(GoogleTest)
include(UnitTest)
include(Coverage)
CombineCoverageReports()

################################################################################
# Add your test here:
add_subdirectory(Configuration)
################################################################################

# Set ctest target
add_custom_target(${PROJECT_NAME}
    COMMAND ${CMAKE_CTEST_COMMAND} --verbose --output-on-failure || true
    WORKING_DIRECTORY ${UNIT_TESTS_BINARY_DIR}
)

# Add post unit test build command
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${UNIT_TESTS_REPORT_DIR}
    COMMAND python3 ${CMAKE_SOURCE_DIR}/utils/unit_tests_report.py ${UNIT_TESTS_BINARY_DIR} ${UNIT_TESTS_REPORT_DIR}
    COMMAND make coverage-all
    WORKING_DIRECTORY ${UNIT_TESTS_BINARY_DIR}
    COMMENT "Generating HTML reports from XML unit_test results."
)

# Format Unit Tests source code
include(ClangFormat)
Format(${PROJECT_NAME} .)
