project(unit_tests LANGUAGES CXX)




# Include GoogleTest fetched in the main CMakeLists.txt
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

# Enable testing with CTest
enable_testing()
# GoolgeTest will be used
include(GoogleTest)


# Set variables
set(APP_DIR ${CMAKE_SOURCE_DIR}/src)
set(TEST_BINARY_DIR ${CMAKE_BINARY_DIR}/test)

# Include packages
#include(Testing)
# Include the unittest cmake config. Use it for all unitests
include(UnitTest)

################################################################################
# Add your test here:
add_subdirectory(Configuration)
################################################################################

# # Set ctest verbosity
add_custom_target(${PROJECT_NAME} COMMAND ${CMAKE_CTEST_COMMAND} --verbose)

# # Add code coverage target
# add_custom_target(code_coverage
#     COMMAND mkdir -p code_coverage_dir
#     WORKING_DIRECTORY ${TEST_BINARY_DIR}
# )

# add_custom_command(TARGET code_coverage
#     COMMAND echo "=============== GENERATING CODE COVERAGE RESULTS... ==============="
#     COMMAND echo "--> Running LCOV on generated GCOV files..."
#     COMMAND lcov --capture  --directory --directory --output-file ./code_coverage.info --exclude '*/3rdparty/*' --exclude '*/test/*' --rc lcov_branch_coverage=1
#     COMMAND lcov --remove ./code_coverage.info  '/usr/include/*' --output-file ./filtered_code_coverage.info --rc lcov_branch_coverage=1
#     COMMAND echo "--> Generating LCOV HTML output files..."
#     COMMAND genhtml ./filtered_code_coverage.info --output-directory . --show-details --legend  --title "MPIC Project code coverage report" --rc genhtml_branch_coverage=1
#     WORKING_DIRECTORY ${TEST_BINARY_DIR}/code_coverage_dir
# )
