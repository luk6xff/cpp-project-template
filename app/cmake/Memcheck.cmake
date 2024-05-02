function(AddMemcheck target output_dir)
  include(FetchContent)
  FetchContent_Declare(
    memcheck-cover
    GIT_REPOSITORY https://github.com/Farigh/memcheck-cover.git
    GIT_TAG        release-1.2
  )
  FetchContent_MakeAvailable(memcheck-cover)
  set(MEMCHECK_PATH ${memcheck-cover_SOURCE_DIR}/bin)

  add_custom_target(memcheck-${target}
    COMMAND ${MEMCHECK_PATH}/memcheck_runner.sh -o
            "${output_dir}/memcheck_report/report"
            -- $<TARGET_FILE:${target}>
    COMMAND ${MEMCHECK_PATH}/generate_html_report.sh
            -i "${output_dir}/memcheck_report"
            -o "${output_dir}/memcheck_report"
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
endfunction()
