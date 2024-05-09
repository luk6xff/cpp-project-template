project(fuzzing_tests LANGUAGES CXX)

# Set variables
set(APP_DIR ${CMAKE_SOURCE_DIR}/src)

# Add the source files
add_executable(ConfigReaderFuzzer
            fuzz_ConfigReader.cpp
            ${APP_DIR}/Configuration/ConfigReader.cpp
)

# Enable fuzzer
target_compile_options(ConfigReaderFuzzer PRIVATE -fsanitize=fuzzer)
target_link_options(ConfigReaderFuzzer PRIVATE -fsanitize=fuzzer)
target_compile_options(ConfigReaderFuzzer PRIVATE -fsanitize=address)
target_link_options(ConfigReaderFuzzer PRIVATE -fsanitize=address)

# Include necessary directories
target_include_directories(ConfigReaderFuzzer PRIVATE ${APP_DIR})

# Set fuzzer specific options
set_target_properties(ConfigReaderFuzzer PROPERTIES
    FUZZ_CONFIGURE_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/fuzzing"
)
