#pragma once

#include "Configuration/Difficulty.h"
#include "Configuration/Resolution.h"

#include <fstream>
#include <iostream>
#include <memory>
#include <sstream>
#include <string>

/**
 * @interface IFileStreamFactory
 * @brief Interface for creating file streams,
 * abstracting the file stream creation mechanism.
 *
 * This interface allows for creating input and
 * output streams, potentially allowing for
 * different implementations depending on the
 * underlying system or testing needs.
 */
class IFileStreamFactory
{
public:
    /**
     * @brief Destroys the file stream factory.
     */
    virtual ~IFileStreamFactory() = default;

    /**
     * @brief Creates an input stream for a given
     * file path.
     * @param path The file path to create an
     * input stream for.
     * @return A unique pointer to an input
     * stream.
     */
    virtual std::unique_ptr<std::istream> createInputStream(const std::string& path) const = 0;

    /**
     * @brief Creates an output stream for a given
     * file path.
     * @param path The file path to create an
     * output stream for.
     * @return A unique pointer to an output
     * stream.
     */
    virtual std::unique_ptr<std::ostream> createOutputStream(const std::string& path) const = 0;
};

/**
 * @class FileStreamFactory
 * @brief Concrete implementation of the
 * IFileStreamFactory interface for file streams.
 *
 * Provides methods to create standard file input
 * and output streams using std::ifstream and
 * std::ofstream.
 */
class FileStreamFactory : public IFileStreamFactory
{
public:
    /**
     * @brief Creates a file input stream.
     * @param path The file path to open for
     * reading.
     * @return A unique pointer to a std::istream.
     */
    std::unique_ptr<std::istream> createInputStream(const std::string& path) const override
    {
        return std::make_unique<std::ifstream>(path, std::ifstream::in);
    }

    /**
     * @brief Creates a file output stream.
     * @param path The file path to open for
     * writing. The file is truncated.
     * @return A unique pointer to a std::ostream.
     */
    std::unique_ptr<std::ostream> createOutputStream(const std::string& path) const override
    {
        return std::make_unique<std::ofstream>(path, std::ofstream::out | std::ofstream::trunc);
    }
};

/**
 * @class ConfigReader
 * @brief Reads configuration settings from a file
 * using a file stream factory.
 *
 * ConfigReader is responsible for loading game
 * settings like resolution and difficulty from a
 * configuration file specified at the creation of
 * the reader instance.
 */
class ConfigReader
{
public:
    /**
     * @brief Constructs a ConfigReader with
     * specified path and file stream factory.
     * @param configurationFilePath The file path
     * to the configuration file.
     * @param fileStreamFactory Reference to an
     * IFileStreamFactory for creating file
     * streams.
     */
    explicit ConfigReader(const std::string& configurationFilePath, const IFileStreamFactory& fileStreamFactory);

    /**
     * @brief Loads game settings from a file.
     * @param resolutionSetting Reference to store
     * the loaded resolution setting.
     * @param difficultyLevel Reference to store
     * the loaded difficulty level.
     */
    void loadSettingsFromFile(Resolution::Setting& resolutionSetting, Difficulty::Level& difficultyLevel);

    /**
     * @brief Creates a default configuration file
     * using provided settings.
     * @param fileStreamFactory Reference to an
     * IFileStreamFactory for creating file
     * streams.
     */
    static void createDefaultConfigurationFile(const IFileStreamFactory& fileStreamFactory);

private:
    std::string m_configurationFilePath;           ///< Path to the
                                                   ///< configuration
                                                   ///< file.
    const IFileStreamFactory& m_fileStreamFactory; ///< File stream
                                                   ///< factory used for
                                                   ///< creating
                                                   ///< streams.

    /**
     * @brief Parses the resolution setting from a
     * string.
     * @param resolutionString The string
     * representation of the resolution.
     * @param resolutionSetting Reference to store
     * the parsed setting.
     * @return True if parsing was successful,
     * false otherwise.
     */
    static bool parseResolutionSetting(const std::string& resolutionString, Resolution::Setting& resolutionSetting);

    /**
     * @brief Parses the difficulty level from a
     * string.
     * @param difficultyString The string
     * representation of the difficulty.
     * @param difficultyLevel Reference to store
     * the parsed level.
     * @return True if parsing was successful,
     * false otherwise.
     */
    static bool parseDifficultyLevel(const std::string& difficultyString, Difficulty::Level& difficultyLevel);
};
