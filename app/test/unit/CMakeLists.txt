cmake_minimum_required(VERSION 3.22)
project(UnitTests LANGUAGES CXX)


# Set variables
set(APP_DIR ${CMAKE_SOURCE_DIR}/src)
set(TEST_BINARY_DIR ${CMAKE_BINARY_DIR}/test)


# Include directories
include_directories(${CMAKE_SOURCE_DIR}/src)
include_directories(${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})

################################################################################
# Add your test here:
add_subdirectory(Configuration)
################################################################################

# Set ctest verbosity
add_custom_target(tests COMMAND ${CMAKE_CTEST_COMMAND} --verbose)

# Add code coverage target
add_custom_target(code_coverage
    COMMAND mkdir -p code_coverage_dir
    WORKING_DIRECTORY ${TEST_BINARY_DIR}
)

add_custom_command(TARGET code_coverage
    COMMAND echo "=============== GENERATING CODE COVERAGE RESULTS... ==============="
    COMMAND echo "--> Running LCOV on generated GCOV files..."
    COMMAND lcov --capture  --directory --directory --output-file ./code_coverage.info --exclude '*/3rdparty/*' --exclude '*/test/*' --rc lcov_branch_coverage=1
    COMMAND lcov --remove ./code_coverage.info  '/usr/include/*' --output-file ./filtered_code_coverage.info --rc lcov_branch_coverage=1
    COMMAND echo "--> Generating LCOV HTML output files..."
    COMMAND genhtml ./filtered_code_coverage.info --output-directory . --show-details --legend  --title "MPIC Project code coverage report" --rc genhtml_branch_coverage=1
    WORKING_DIRECTORY ${TEST_BINARY_DIR}/code_coverage_dir
)
