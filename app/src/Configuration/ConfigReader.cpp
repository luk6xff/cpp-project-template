#include "ConfigReader.h"

ConfigReader::ConfigReader(const std::string& configurationFilePath, const IFileStreamFactory& fileStreamFactory)
    : m_configurationFilePath(configurationFilePath)
    , m_fileStreamFactory(fileStreamFactory)
{
}

void ConfigReader::loadSettingsFromFile(Resolution::Setting& resolutionSetting, Difficulty::Level& difficultyLevel)
{
    auto inputFile = m_fileStreamFactory.createInputStream(m_configurationFilePath);
    if (!inputFile->good())
    {
        std::cout << "Failed to open "
                     "configuration file.\n";
        createDefaultConfigurationFile(m_fileStreamFactory);
        return;
    }

    std::string line;
    while (std::getline(*inputFile, line))
    {
        std::istringstream lineStream(line);
        std::string key;
        while (lineStream >> key)
        {
            if (key[0] == '#')
                break;

            if (key == "resolution")
            {
                std::string resolutionArg;
                if (lineStream >> resolutionArg && !parseResolutionSetting(resolutionArg, resolutionSetting))
                    std::cout << "Invalid resolution "
                                 "setting in "
                                 "configuration file."
                              << std::endl;
            }
            else if (key == "difficulty")
            {
                std::string difficultyArg;
                if (lineStream >> difficultyArg && !parseDifficultyLevel(difficultyArg, difficultyLevel))
                    std::cout << "Invalid difficulty "
                                 "level in "
                                 "configuration file."
                              << std::endl;
            }
        }
    }
}

void ConfigReader::createDefaultConfigurationFile(const IFileStreamFactory& fileStreamFactory)
{
    auto outputFile = fileStreamFactory.createOutputStream("config.txt");
    if (!outputFile->good())
    {
        std::cout << "Failed to create the "
                     "default configuration file."
                  << std::endl;
        return;
    }

    *outputFile << "#Resolution\n#Options: 600x800, "
                   "768x1024, 864x1152, "
                   "960x1280\nresolution 864x1152\n\n"
                << "#Difficulty\n#Options: easy, normal, "
                   "hard\ndifficulty normal\n";

    if (!outputFile->good())
        std::cout << "Error occurred while writing the "
                     "default configuration file."
                  << std::endl;
}

bool ConfigReader::parseResolutionSetting(const std::string& resolutionString, Resolution::Setting& resolutionSetting)
{
    auto result = Resolution::stringToResolution(resolutionString);
    if (result.has_value())
    {
        resolutionSetting = result.value();
        return true;
    }
    return false;
}

bool ConfigReader::parseDifficultyLevel(const std::string& difficultyString, Difficulty::Level& difficultyLevel)
{
    auto result = Difficulty::stringToDifficulty(difficultyString);
    if (result.has_value())
    {
        difficultyLevel = result.value();
        return true;
    }
    return false;
}
