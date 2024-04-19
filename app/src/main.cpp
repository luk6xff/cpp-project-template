#include "Configuration/ConfigReader.h"
#include "Configuration/Difficulty.h"
#include "Configuration/Resolution.h"
#include "Game/Game.h"

#include <iostream>

int main(int argc, char** argv)
{
    Resolution::Setting gameRes  = Resolution::Setting::h864w1152;
    Difficulty::Level difficulty = Difficulty::Level::Normal;

    FileStreamFactory fileStreamFactory;

    ConfigReader configReader("config.txt", fileStreamFactory);
    configReader.loadSettingsFromFile(gameRes, difficulty);

    Game game{gameRes, difficulty};
    game.run();

    return 0;
}
