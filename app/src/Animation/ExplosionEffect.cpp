#include "ExplosionEffect.h"

ExplosionEffect::ExplosionEffect(std::vector<sf::Texture>& textures) : Animation(textures) {}

void ExplosionEffect::play() {
    m_isPlaying = true;
    m_currentFrame = 0;
}

void ExplosionEffect::drawNext(sf::RenderWindow& window) {
    if (m_isPlaying) {
        // Get index of the frame drawn by draw
        m_currentFrame = draw(window);

        // Stop playing if it's the last frame
        if (m_currentFrame == m_frames.size() - 1) {
            m_isPlaying = false;
        }
    }
}
