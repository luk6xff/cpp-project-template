#include "Configuration/ConfigReader.h"
#include "Configuration/Difficulty.h"
#include "Configuration/Resolution.h"
#include "Game/ExecutablePath.h"
#include "Game/Game.h"

#include <filesystem>
#include <iostream>
#include <profiler.h>

namespace fs = std::filesystem;

int main()
{

    // Enable the profiler
    EASY_PROFILER_ENABLE;
    profiler::startListen();

    Resolution::Setting gameRes  = Resolution::Setting::h600w800; // h864w1152;
    Difficulty::Level difficulty = Difficulty::Level::Normal;

    FileStreamFactory fileStreamFactory;

    // ConfigReader configReader("config.txt", fileStreamFactory);
    // configReader.loadSettingsFromFile(gameRes, difficulty);

    // Obtain the path to the current executable
    fs::path execDirPath = executable_path::getExecutableDirPath();
    std::cout << "Current Executable directory path is: " << execDirPath << std::endl;

    Game game{execDirPath, gameRes, difficulty};
    game.run();

    return 0;
}
