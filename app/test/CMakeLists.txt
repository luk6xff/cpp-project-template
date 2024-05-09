project(tests)


if (UNIT_TESTS)
  add_subdirectory(unit)
endif()

if (INTEGRATION_TESTS)
  add_subdirectory(integration)
endif()

if (SYSTEM_TESTS)
  add_subdirectory(system)
endif()

if (FUZZING_TESTS)
  add_subdirectory(fuzzing)
endif()

