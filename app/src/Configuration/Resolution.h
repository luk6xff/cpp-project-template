#pragma once

#include <optional>
#include <string>
#include <utility>

/**
 * @namespace Resolution
 * @brief Provides utilities for managing screen
 * resolutions.
 *
 * This namespace contains an enumeration of
 * standard screen resolution settings and
 * functions to convert these settings to string
 * representations or to numerical width and
 * height pairs.
 */
namespace Resolution
{

/**
 * @enum Setting
 * @brief Enumerates standard screen resolution
 * settings.
 */
enum class Setting
{
    h600w800,  ///< Resolution of 800x600 pixels.
    h768w1024, ///< Resolution of 1024x768 pixels.
    h864w1152, ///< Resolution of 1152x864 pixels.
    h960w1280  ///< Resolution of 1280x960 pixels.
};

/**
 * @brief Converts a resolution setting to its
 * corresponding width and height.
 * @param res The resolution setting to convert.
 * @return A pair containing the width and height
 * in pixels.
 */
std::pair<uint32_t, uint32_t> getIntFromResolution(Setting res);

/**
 * @brief Converts a resolution setting to a
 * human-readable string format.
 * @param resolution The resolution setting to
 * convert.
 * @return A string representing the resolution,
 * formatted as "WxH".
 */
std::string resolutionToStr(Setting resolution);

/**
 * @brief Converts a string representation of a
 * resolution to a Resolution::Setting.
 * @param str The string to convert, expected to
 * be in the format "WxH".
 * @return An optional containing the
 * corresponding Resolution::Setting if the string
 * is valid, or an empty optional if the string
 * does not correspond to a known resolution.
 */
std::optional<Setting> stringToResolution(const std::string& str);
} // namespace Resolution
