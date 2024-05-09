#include "Difficulty.h"

std::optional<Difficulty::Level> Difficulty::stringToDifficulty(const std::string& str)
{
    if (str == "easy")
        return Difficulty::Level::Easy;
    if (str == "normal")
        return Difficulty::Level::Normal;
    if (str == "hard")
        return Difficulty::Level::Hard;
    return std::nullopt;
}

std::string Difficulty::difficultyToString(Difficulty::Level difficulty)
{
    switch (difficulty)
    {
        case Level::Easy:
            return "easy";
        case Level::Normal:
            return "normal";
        case Level::Hard:
            return "hard";
        default:
            return {}; // Should never be reached;
                       // included to suppress
                       // warnings
    }
}
