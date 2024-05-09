#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include "Configuration/ConfigReader.h"

// Define a dummy file stream factory
class DummyFileStreamFactory : public IFileStreamFactory {
public:
    std::unique_ptr<std::istream> createInputStream([[maybe_unused]] const std::string& filePath) const override {

        return nullptr; // Dummy implementation, returns nullptr
    }

    std::unique_ptr<std::ostream> createOutputStream([[maybe_unused]] const std::string& filePath) const override {
        return nullptr; // Dummy implementation, returns nullptr
    }
};

// Define the entry point for libFuzzer
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size);

// Entry point for libFuzzer
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    // Input data can be used to fuzz the ConfigReader class
    std::string input(reinterpret_cast<const char*>(data), size);
    std::istringstream stream(input);

    // Convert input data to a string
    std::string inputData(reinterpret_cast<const char*>(data), size);

    // Create a ConfigReader object with a dummy file stream factory
    ConfigReader configReader("dummy_configuration_file_path", DummyFileStreamFactory());

    // Load settings from the input data
    Resolution::Setting resolutionSetting;
    Difficulty::Level difficultyLevel;
    configReader.parseConfigurationFile(stream, resolutionSetting, difficultyLevel);

    return 0;
}
