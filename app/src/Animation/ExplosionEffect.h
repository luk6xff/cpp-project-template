#pragma once
#include "Animation/Animation.h"

/**
 * @brief A specialized animation that plays only
 * once from the first to the last frame.
 */
class ExplosionEffect : public Animation
{
protected:
    sf::Int32 m_lastTimeDrawn = 0; ///< Last time the frame was drawn, for
                                   ///< timing.
    bool m_isPlaying = false;      ///< Flag to check if the effect is
                                   ///< currently playing.
    uint32_t m_currentFrame = 0;   ///< Index of the current frame being
                                   ///< displayed.

public:
    /**
     * @brief Constructs an ExplosionEffect object
     * using a vector of textures.
     * @param textures Vector of textures to be
     * used in the animation.
     */
    explicit ExplosionEffect(std::vector<sf::Texture>& textures);

    /**
     * @brief Starts playing the effect from the
     * first frame.
     */
    void play();

    /**
     * @brief Draws the next frame in the sequence
     * or stops if at the end.
     * @param window Reference to the render
     * window where the effect will be drawn.
     */
    void drawNext(sf::RenderWindow& window);

    /**
     * @brief Virtual destructor for potential
     * future expansion.
     */
    virtual ~ExplosionEffect()
    {
    }
};
