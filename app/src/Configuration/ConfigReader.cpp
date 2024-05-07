#include "ConfigReader.h"
#include <iostream>
#include <sstream>

ConfigReader::ConfigReader(const std::string &configurationFilePath,
                           const IFileStreamFactory &fileStreamFactory)
    : m_configurationFilePath(configurationFilePath),
      m_fileStreamFactory(fileStreamFactory) {}

void ConfigReader::loadSettingsFromFile(Resolution::Setting &resolutionSetting,
                                        Difficulty::Level &difficultyLevel) {
  auto inputFile =
      m_fileStreamFactory.createInputStream(m_configurationFilePath);
  if (!inputFile || !inputFile->good()) {
    std::cout << "Failed to open configuration file.\n";
    createDefaultConfigurationFile();
    return;
  }

  parseConfigurationFile(*inputFile, resolutionSetting, difficultyLevel);
}

void ConfigReader::parseConfigurationFile(
    std::istream &inputFile, Resolution::Setting &resolutionSetting,
    Difficulty::Level &difficultyLevel) {
  std::string line;
  while (std::getline(inputFile, line)) {
    processConfigurationLine(line, resolutionSetting, difficultyLevel);
  }
}

void ConfigReader::processConfigurationLine(
    const std::string &line, Resolution::Setting &resolutionSetting,
    Difficulty::Level &difficultyLevel) {
  std::istringstream lineStream(line);
  std::string key;
  while (lineStream >> key) {
    if (key[0] == '#')
      return; // Ignore comments

    if (key == "resolution") {
      parseResolution(lineStream, resolutionSetting);
    } else if (key == "difficulty") {
      parseDifficulty(lineStream, difficultyLevel);
    }
  }
}

void ConfigReader::parseResolution(std::istringstream &lineStream,
                                   Resolution::Setting &resolutionSetting) {
  std::string resolutionArg;
  if (!(lineStream >> resolutionArg &&
        parseResolutionSetting(resolutionArg, resolutionSetting))) {
    std::cout << "Invalid resolution setting in configuration file."
              << std::endl;
  }
}

void ConfigReader::parseDifficulty(std::istringstream &lineStream,
                                   Difficulty::Level &difficultyLevel) {
  std::string difficultyArg;
  if (!(lineStream >> difficultyArg &&
        parseDifficultyLevel(difficultyArg, difficultyLevel))) {
    std::cout << "Invalid difficulty level in configuration file." << std::endl;
  }
}

void ConfigReader::createDefaultConfigurationFile() {
  auto outputFile = m_fileStreamFactory.createOutputStream("config.txt");
  if (!outputFile || !outputFile->good()) {
    std::cout << "Failed to create the default configuration file."
              << std::endl;
    return;
  }

  *outputFile
      << "#Resolution\n#Options: 600x800, 768x1024, 864x1152, 960x1280\n"
      << "resolution 864x1152\n\n#Difficulty\n#Options: easy, normal, hard\n"
      << "difficulty normal\n";

  if (!outputFile->good())
    std::cout << "Error occurred while writing the default configuration file."
              << std::endl;
}

bool ConfigReader::parseResolutionSetting(
    const std::string &resolutionString,
    Resolution::Setting &resolutionSetting) {
  auto result = Resolution::stringToResolution(resolutionString);
  if (result.has_value()) {
    resolutionSetting = result.value();
    return true;
  }
  return false;
}

bool ConfigReader::parseDifficultyLevel(const std::string &difficultyString,
                                        Difficulty::Level &difficultyLevel) {
  auto result = Difficulty::stringToDifficulty(difficultyString);
  if (result.has_value()) {
    difficultyLevel = result.value();
    return true;
  }
  return false;
}
