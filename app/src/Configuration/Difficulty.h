#pragma once

#include <optional>
#include <string>

/**
 * @namespace Difficulty
 * @brief Provides utilities for managing game
 * difficulty levels.
 *
 * This namespace contains an enumeration of
 * standard game difficulty levels and functions
 * to convert these levels to and from string
 * representations.
 */
namespace Difficulty
{

/**
 * @enum Level
 * @brief Enumerates standard game difficulty
 * levels.
 */
enum class Level
{
    Easy,   ///< Represents an easy difficulty
            ///< level.
    Normal, ///< Represents a normal difficulty
            ///< level.
    Hard    ///< Represents a hard difficulty level.
};

/**
 * @brief Converts a difficulty level to its
 * corresponding string representation.
 * @param difficulty The difficulty level to
 * convert.
 * @return A string representing the difficulty
 * level ("Easy", "Normal", "Hard").
 */
std::string difficultyToString(Level difficulty);

/**
 * @brief Converts a string representation of a
 * difficulty level to a Difficulty::Level.
 * @param str The string to convert, expected to
 * match one of "Easy", "Normal", "Hard".
 * @return An optional containing the
 * corresponding Difficulty::Level if the string
 * is valid, or an empty optional if the string
 * does not match a known difficulty level.
 */
std::optional<Level> stringToDifficulty(const std::string& str);
} // namespace Difficulty
