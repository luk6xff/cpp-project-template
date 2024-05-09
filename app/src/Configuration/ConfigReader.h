#pragma once

#include "Configuration/Difficulty.h"
#include "Configuration/Resolution.h"

#include <fstream>
#include <iostream>
#include <memory>
#include <sstream>
#include <string>

/**
 * @brief Interface for creating file streams,
 * abstracting the file stream creation mechanism.
 */
class IFileStreamFactory
{
public:
    virtual ~IFileStreamFactory() = default;

    /**
     * @brief Creates an input stream for a given file path.
     * @param path The file path to create an input stream for.
     * @return A unique pointer to an input stream.
     */
    virtual std::unique_ptr<std::istream> createInputStream(const std::string& path) const = 0;

    /**
     * @brief Creates an output stream for a given file path.
     * @param path The file path to create an output stream for.
     * @return A unique pointer to an output stream.
     */
    virtual std::unique_ptr<std::ostream> createOutputStream(const std::string& path) const = 0;
};

/**
 * @brief Concrete implementation of the IFileStreamFactory interface.
 */
class FileStreamFactory : public IFileStreamFactory
{
public:
    std::unique_ptr<std::istream> createInputStream(const std::string& path) const override
    {
        return std::make_unique<std::ifstream>(path, std::ifstream::in);
    }

    std::unique_ptr<std::ostream> createOutputStream(const std::string& path) const override
    {
        return std::make_unique<std::ofstream>(path, std::ofstream::out | std::ofstream::trunc);
    }
};

/**
 * @class ConfigReader
 * @brief Reads configuration settings from a configuration file.
 *
 * The ConfigReader is responsible for loading settings such as resolution
 * and difficulty levels from a configuration file. The class utilizes an
 * IFileStreamFactory to abstract the creation of file streams, which allows
 * for easier testing and flexibility in file stream implementations.
 */
class ConfigReader
{
public:
    /**
     * @brief Constructs a ConfigReader with a specified path and file stream
     * factory.
     * @param configurationFilePath Path to the configuration file.
     * @param fileStreamFactory Reference to an IFileStreamFactory for creating
     * file streams.
     */
    ConfigReader(const std::string& configurationFilePath, const IFileStreamFactory& fileStreamFactory);

    /**
     * @brief Loads game settings from the configuration file.
     * @param resolutionSetting Reference to store the loaded resolution setting.
     * @param difficultyLevel Reference to store the loaded difficulty level.
     */
    void loadSettingsFromFile(Resolution::Setting& resolutionSetting, Difficulty::Level& difficultyLevel);

private:
    std::string m_configurationFilePath;           ///< Path to the configuration file.
    const IFileStreamFactory& m_fileStreamFactory; ///< File stream factory used for creating streams.

    /**
     * @brief Parses the entire configuration file.
     * @param inputFile Input stream of the configuration file.
     * @param resolutionSetting Reference to store the loaded resolution setting.
     * @param difficultyLevel Reference to store the loaded difficulty level.
     */
    void parseConfigurationFile(
        std::istream& inputFile,
        Resolution::Setting& resolutionSetting,
        Difficulty::Level& difficultyLevel);

    /**
     * @brief Processes each line of the configuration file.
     * @param line String containing a single line from the configuration file.
     * @param resolutionSetting Reference to store the resolution if parsed
     * successfully.
     * @param difficultyLevel Reference to store the difficulty if parsed
     * successfully.
     */
    void processConfigurationLine(
        const std::string& line,
        Resolution::Setting& resolutionSetting,
        Difficulty::Level& difficultyLevel);

    /**
     * @brief Parses resolution settings from a string stream.
     * @param lineStream Input string stream containing the resolution settings.
     * @param resolutionSetting Reference to store the parsed resolution setting.
     */
    void parseResolution(std::istringstream& lineStream, Resolution::Setting& resolutionSetting);

    /**
     * @brief Parses difficulty levels from a string stream.
     * @param lineStream Input string stream containing the difficulty levels.
     * @param difficultyLevel Reference to store the parsed difficulty level.
     */
    void parseDifficulty(std::istringstream& lineStream, Difficulty::Level& difficultyLevel);

    /**
     * @brief Parses and validates the resolution setting from a string.
     * @param resolutionString String representing the resolution.
     * @param resolutionSetting Reference to store the parsed resolution setting.
     * @return True if the parsing and validation are successful, false otherwise.
     */
    static bool parseResolutionSetting(const std::string& resolutionString, Resolution::Setting& resolutionSetting);

    /**
     * @brief Parses and validates the difficulty level from a string.
     * @param difficultyString String representing the difficulty level.
     * @param difficultyLevel Reference to store the parsed difficulty level.
     * @return True if the parsing and validation are successful, false otherwise.
     */
    static bool parseDifficultyLevel(const std::string& difficultyString, Difficulty::Level& difficultyLevel);

    /**
     * @brief Creates a default configuration file if the main configuration file
     * is not accessible.
     * @param fileStreamFactory File stream factory to use for creating the output
     * stream.
     */
    void createDefaultConfigurationFile();
};
