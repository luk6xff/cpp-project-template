set(COVERAGE_OUTPUT_DIR ${UNIT_TESTS_BINARY_DIR}/coverage)


function(CleanCoverage target)
  add_custom_command(TARGET ${target} PRE_BUILD COMMAND
                     find ${CMAKE_BINARY_DIR} -type f
                     -name '*.gcda' -exec rm {} +)
endfunction()


function(AddCoverage target)
  find_program(LCOV_PATH lcov REQUIRED)
  find_program(GENHTML_PATH genhtml REQUIRED)

  # Add coverage flags
  target_compile_options(${target} PRIVATE --coverage -fno-inline)
  target_link_options(${target} PUBLIC --coverage)

  # This custom target now only initializes coverage counters and runs tests
  add_custom_target(coverage-${target}
    COMMAND ${LCOV_PATH} --directory ${UNIT_TESTS_BINARY_DIR} --zerocounters
    COMMAND $<TARGET_FILE:${target}>
    COMMAND ${LCOV_PATH} --directory ${UNIT_TESTS_BINARY_DIR} --capture --output-file ${COVERAGE_OUTPUT_DIR}/coverage-${target}.info
    WORKING_DIRECTORY ${UNIT_TESTS_BINARY_DIR}
    COMMENT "Running coverage for target ${target}..."
  )
endfunction()


# Function to combine all coverage reports and generate HTML
function(CombineCoverageReports)
  find_program(LCOV_PATH lcov REQUIRED)
  find_program(GENHTML_PATH genhtml REQUIRED)

  # Aggregate all coverage.info files from all targets
  add_custom_target(coverage-all
    COMMAND ${CMAKE_COMMAND} -E make_directory ${COVERAGE_OUTPUT_DIR}
    COMMAND ${LCOV_PATH} --directory ${UNIT_TESTS_BINARY_DIR} --capture --output-file ${COVERAGE_OUTPUT_DIR}/combined_coverage.info
    COMMAND ${LCOV_PATH} --remove  ${COVERAGE_OUTPUT_DIR}/combined_coverage.info '/usr/*' '_deps/*' '*/test/*' '*/googletest/*' '*/gmock/*' --output-file ${COVERAGE_OUTPUT_DIR}/filtered_coverage.info
    COMMAND ${GENHTML_PATH} --output-directory ${UNIT_TESTS_REPORT_DIR}/coverage-report --show-details --rc genhtml_branch_coverage=1 --legend --title "Overall Unit Tests Coverage" ${COVERAGE_OUTPUT_DIR}/filtered_coverage.info
    COMMAND ${CMAKE_COMMAND} -E remove ${COVERAGE_OUTPUT_DIR}/combined_coverage.info  ${COVERAGE_OUTPUT_DIR}/filtered_coverage.info
    WORKING_DIRECTORY  ${UNIT_TESTS_BINARY_DIR}
    COMMENT "Generating combined coverage report..."
  )
endfunction()
