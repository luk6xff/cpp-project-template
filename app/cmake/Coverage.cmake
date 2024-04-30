function(CleanCoverage target)
  add_custom_command(TARGET ${target} PRE_BUILD COMMAND
                     find ${CMAKE_BINARY_DIR} -type f
                     -name '*.gcda' -exec rm {} +)
endfunction()


function(AddCoverage target)
  find_program(LCOV_PATH lcov REQUIRED)
  find_program(GENHTML_PATH genhtml REQUIRED)
  if (CMAKE_BUILD_TYPE STREQUAL Debug)
    target_compile_options(${target} PRIVATE --coverage -fno-inline)
    target_link_options(${target} PUBLIC --coverage)
  endif()

  # This custom target now only initializes coverage counters and runs tests
  add_custom_target(coverage-${target}
    COMMAND ${LCOV_PATH} --directory ${CMAKE_BINARY_DIR} --zerocounters
    COMMAND $<TARGET_FILE:${target}>
    COMMAND ${LCOV_PATH} --directory ${CMAKE_BINARY_DIR} --capture --output-file ${CMAKE_BINARY_DIR}/coverage-${target}.info
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running coverage for target ${target}"
  )
endfunction()


# Function to combine all coverage reports and generate HTML
function(CombineCoverageReports)
  find_program(LCOV_PATH lcov REQUIRED)
  find_program(GENHTML_PATH genhtml REQUIRED)

  # Aggregate all coverage.info files from all targets
  add_custom_target(coverage-all
    COMMAND ${LCOV_PATH} --directory ${CMAKE_BINARY_DIR}/test/unit --capture --output-file combined_coverage.info
    COMMAND ${LCOV_PATH} --remove combined_coverage.info '/usr/*' '_deps/*' '*/test/*' '*/googletest/*' '*/gmock/*' --output-file filtered_coverage.info
    COMMAND ${GENHTML_PATH} --output-directory coverage-html --legend --title "Overall Unit Tests Coverage" filtered_coverage.info
    COMMAND ${CMAKE_COMMAND} -E remove combined_coverage.info filtered_coverage.info
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Generating combined coverage report"
  )
endfunction()
