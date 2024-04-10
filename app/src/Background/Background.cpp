#include "Background.h"

Background::Background(const sf::Texture& bgTexture, uint32_t screenWidth, uint32_t screenHeight) {
    m_width = static_cast<float>(screenWidth);
    m_height = static_cast<float>(screenHeight);

    // Factors to scale the sprite so it is the same size as the screen
    sf::Vector2f factors(m_width / bgTexture.getSize().x, m_height / bgTexture.getSize().y);

    // Initialize sprites with texture and scale
    for (sf::Sprite& frame : m_frames) {
        frame.setTexture(bgTexture);
        frame.setScale(factors);
    }

    // Set the second sprite just above the first one to create a continuous loop effect
    m_frames[1].setPosition(0, -m_height);
}

void Background::moveDown(float offset) {
    for (sf::Sprite& frame : m_frames) {
        // Move the sprite downward
        frame.move(0, offset);

        // If the sprite moves below the screen, reset its position above the screen
        if (frame.getPosition().y > m_height) {
            frame.setPosition(0, -m_height);
        }
    }
}

void Background::draw(sf::RenderWindow& window) {
    // Draw both sprites
    for (const sf::Sprite& frame : m_frames) {
        window.draw(frame);
    }
}
