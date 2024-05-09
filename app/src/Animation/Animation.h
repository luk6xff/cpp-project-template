#pragma once

#include <SFML/Graphics.hpp>
#include <vector>

/**
 * @brief Class to manage animations with looping
 * capabilities, using SFML.
 */
class Animation
{
protected:
    bool m_firstDraw = true;       ///< Flag to check if it's the first
                                   ///< time the animation is drawn.
    bool m_invisible = false;      ///< Flag to set the visibility of
                                   ///< the animation.
    bool m_isLooping = true;       ///< Determines if the animation
                                   ///< should loop
    size_t m_currentFrame = 0;     ///< Current frame index
    bool m_playing        = false; ///< Animation is active

    sf::Color m_flashColor = sf::Color::White; ///< Color to flash the
                                               ///< animation frames.
    int m_flashMsDuration = 0;                 ///< Duration in milliseconds for the
                                               ///< flash effect.
    sf::Int32 m_flashStart = 0;                ///< Start time for the flash effect.

    sf::Clock m_clock;                ///< Clock to manage
                                      ///< animation timing.
    sf::Int32 m_msBetweenFrames = 1;  ///< Milliseconds between each frame of
                                      ///< the animation.
    std::vector<sf::Sprite> m_frames; ///< Vector containing all
                                      ///< frames of the animation.

public:
    /**
     * @brief Constructs an Animation object with
     * initial textures.
     * @param textures Vector of SFML textures to
     * initialize the animation frames.
     * @param isLooping Flag to determine if the
     * animation should loop. Default is true.
     */
    explicit Animation(const std::vector<sf::Texture>& textures, bool isLooping = true);

    /**
     * @brief Constructs an Animation object with
     * initial texture.
     * @param texture SFML texture to initialize
     * the animation frame.
     * @param isLooping Flag to determine if the
     * animation should loop. Default is false.
     */
    explicit Animation(const sf::Texture& texture, bool isLooping = false);

    /**
     * @brief Starts or resumes the animation.
     */
    void play();

    /**
     * @brief Stops the animation.
     */
    void stop();

    /**
     * @brief Checks if the animation is currently
     * playing.
     * @return True if the animation is playing,
     * false otherwise.
     */
    bool isPlaying() const;

    // Setters
    /**
     * @brief Sets the scale for all animation
     * frames.
     * @param scaleX The scale factor along the
     * x-axis.
     * @param scaleY The scale factor along the
     * y-axis.
     */
    void setScale(float scaleX, float scaleY);

    /**
     * @brief Sets the position for all animation
     * frames.
     * @param x The x-coordinate of the new
     * position.
     * @param y The y-coordinate of the new
     * position.
     */
    void setPosition(float x, float y);

    // Getters
    /**
     * @brief Retrieves the scale of the animation
     * frames.
     * @return Returns the scale as an SFML
     * Vector2f.
     */
    sf::Vector2f getScale() const;

    /**
     * @brief Retrieves the position of the
     * animation frames.
     * @return Returns the position as an SFML
     * Vector2f.
     */
    sf::Vector2f getPosition() const;

    /**
     * @brief Retrieves the bounding rectangle of
     * the first frame of the animation.
     * @return Returns the bounding rectangle as
     * an SFML FloatRect.
     */
    sf::FloatRect getRect() const;

    /**
     * @brief Switches the textures of all frames
     * in the animation.
     * @param textures Vector of SFML textures to
     * replace the current frames.
     */
    void switchTextures(const std::vector<sf::Texture>& textures);

    /**
     * @brief Draws the animation onto a given
     * SFML render window.
     * @param window Reference to the SFML render
     * window.
     * @return Returns the index of the frame that
     * was drawn.
     */
    int draw(sf::RenderWindow& window);

    /**
     * @brief Sets the milliseconds between each
     * frame of the animation.
     * @param ms Milliseconds between frames.
     */
    void setMsBetweenFrames(int ms);

    // Movement
    void move(float offsetX, float offsetY);
    void moveUp(float speed, int minY);
    void moveDown(float speed, int maxY);
    void moveLeft(float speed, int minX);
    void moveRight(float speed, int maxX);

    /**
     * @brief Initiates a flash effect on the
     * animation frames.
     * @param color Color of the flash effect.
     * @param durationMs Duration of the flash in
     * milliseconds.
     */
    void flash(sf::Color color, int durationMs);

    /**
     * @brief Toggles the visibility of the
     * animation.
     */
    void toggleInvisibility();

    /**
     * @brief Checks if the animation is currently
     * set to invisible.
     * @return Returns true if the animation is
     * invisible, false otherwise.
     */
    bool isInvisible() const;
};
