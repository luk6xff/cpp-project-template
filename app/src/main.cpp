#include <iostream>
#include "Configuration/ConfigReader.h"
#include "Configuration/Resolution.h"
#include "Configuration/Difficulty.h"
#include "Game/Game.h"


int main(int argc, char **argv) {
    Resolution::Setting gameRes = Resolution::Setting::h864w1152;
    Difficulty::Level difficulty = Difficulty::Level::Normal;

    FileStreamFactory fileStreamFactory;

    ConfigReader configReader("config.txt", fileStreamFactory);
    configReader.loadSettingsFromFile(gameRes, difficulty);

    Game game{gameRes, difficulty};
    game.run();

    return 0;
}
