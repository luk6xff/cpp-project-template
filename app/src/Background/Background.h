#pragma once

#include <SFML/Graphics.hpp>
#include <array>

/**
 * @brief Class to manage a continuously scrolling background for a top-down game view.
 */
class Background {
private:
    float m_width;                          ///< Width of the screen.
    float m_height;                         ///< Height of the screen.
    std::array<sf::Sprite, 2> m_frames;     ///< Array of two sprites to create a looping background effect.

public:
    /**
     * @brief Constructs a Background with a texture that covers the screen.
     * @param bgTexture Reference to the texture used for the background.
     * @param screenWidth Width of the screen.
     * @param screenHeight Height of the screen.
     */
    Background(const sf::Texture& bgTexture, uint32_t screenWidth, uint32_t screenHeight);

    /**
     * @brief Moves the background downwards to simulate scrolling.
     * @param offset The amount by which the background moves down each frame.
     */
    void moveDown(float offset);

    /**
     * @brief Draws the background sprites to the window.
     * @param window Reference to the render window where the background will be drawn.
     */
    void draw(sf::RenderWindow& window);
};
