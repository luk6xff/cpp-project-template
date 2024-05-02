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
  if (COMPILER_CHOICE STREQUAL "GCC")
    set(COVERAGE_COMPILE_FLAGS "${COVERAGE_COMPILE_FLAGS} -fprofile-arcs -ftest-coverage")
    set(COVERAGE_LINK_FLAGS "-lgcov -fprofile-arcs -ftest-coverage")
  elseif(COMPILER_CHOICE STREQUAL "CLANG")
    set(COVERAGE_COMPILE_FLAGS "--coverage")
    set(COVERAGE_LINK_FLAGS "--coverage")
  endif()

  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COVERAGE_COMPILE_FLAGS}")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${COVERAGE_LINK_FLAGS}")

  # This custom target now only initializes coverage counters and runs tests
  add_custom_target(coverage-${target}
    COMMAND ${LCOV_PATH} --directory ${UNIT_TESTS_BINARY_DIR} --zerocounters
    COMMAND $<TARGET_FILE:${target}>
    COMMAND ${LCOV_PATH} --directory ${UNIT_TESTS_BINARY_DIR} --capture --output-file ${COVERAGE_OUTPUT_DIR}/coverage-${target}.info
    WORKING_DIRECTORY ${UNIT_TESTS_BINARY_DIR}
    COMMENT "Running coverage for target: ${target}..."
  )

  message(">>>>>>>>>>>CMAKE_CXX_FLAGS = ${CMAKE_CXX_FLAGS}")
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
    COMMENT "Generating combined coverage report..."
  )
endfunction()
