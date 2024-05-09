#pragma once

#include "Animation/Animation.h"
#include "Animation/ExplosionEffect.h"
#include "Background/Background.h"
#include "Configuration/Difficulty.h"
#include "Configuration/Resolution.h"
#include "Game/GameCar.h"

#include <SFML/Graphics.hpp>
#include <array>
#include <cstdlib>
#include <ctime>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <memory>
#include <sstream>
#include <vector>

/**
 * @class Game
 * @brief Manages the main gameplay functions,
 * integrating all components like player,
 * enemies, and effects.
 *
 * This class orchestrates the gameplay, including
 * the game loop, event handling, and rendering.
 * It manages game states like scoring, player
 * lives, and interactions between game elements
 * such as collisions and movements.
 */
class Game
{
public:
    /**
     * @brief Construct a new Game object with
     * specified settings for resolution and
     * difficulty.
     * @param execDirPath Filesystem path to the binary.
     * @param resolutionSetting Screen resolution
     * settings.
     * @param gameDifficulty Difficulty level of
     * the game.
     */
    Game(
        const std::filesystem::path& execDirPath,
        Resolution::Setting resolutionSetting,
        Difficulty::Level gameDifficulty);

    /**
     * @brief Starts the game loop, handling all
     * updates and rendering.
     */
    void run();

private:
    const std::filesystem::path& m_execDirPath; ///< Path to the
                                                ///< executable.
    sf::RenderWindow m_window;                  ///< The main window where the
                                                ///< game is rendered.
    uint32_t m_screenWidth;                     ///< Width of the screen.
    uint32_t m_screenHeight;                    ///< Height of the screen.

    sf::Clock m_playTimeClock; ///< Clock for measuring
                               ///< play time.
    sf::Time m_timePerFrame;   ///< Fixed time step for
                               ///< each frame to ensure
                               ///< consistent updates.
    float m_delta;             ///< Delta time derived from
                               ///< time per frame.

    std::array<int, 3> m_highScores; ///< High scores for each
                                     ///< difficulty level.
    Difficulty::Level m_difficulty;  ///< Current difficulty
                                     ///< level of the game.

    sf::Font m_font; ///< Font used for rendering text.

    // Textures
    sf::Texture m_backgroundTexture;
    sf::Texture m_playerBulletTexture;
    sf::Texture m_enemyBulletTexture;
    sf::Texture m_playerLifeTexture;
    sf::Texture m_playerCarTexture;
    std::vector<sf::Texture> m_enemyCarTextures;
    std::vector<sf::Texture> m_enemyTruckTextures;
    std::vector<sf::Texture> m_enemyExplosionTextures;
    std::vector<sf::Texture> m_playerExplosionTextures;

    // Texts
    sf::Text m_scoreText;
    sf::Text m_highScoreText;
    sf::Text m_restartText;
    sf::Text m_timeText;

    std::unique_ptr<Background> m_background;  ///< Background of the game.
    std::unique_ptr<GameCar> m_player;         ///< Player's car.
    std::vector<GameCar> m_enemies;            ///< List of enemy cars.
    std::vector<sf::Sprite> m_playerBullets;   ///< Player's bullets on
                                               ///< screen.
    std::vector<sf::Sprite> m_enemyBullets;    ///< Enemy bullets on
                                               ///< screen.
    std::vector<ExplosionEffect> m_explosions; ///< Explosions to render.
    std::vector<sf::Sprite> m_lives;           ///< Icons representing player
                                               ///< lives.

    bool m_isRunning = true; ///< Flag to control the game loop.
    float m_lifeScale;       ///< Scaling factor for the
                             ///< life icons.
    int m_enemyCount;        ///< Current number of
                             ///< enemies on screen.
    int m_score;             ///< Current score of the player.

    // Gameplay constants
    const int m_maxPlayerHealth;
    const float m_playerSpeed;
    const float m_enemyCarSpeed;
    const float m_enemyTruckSpeed;
    const float m_playerBulletSpeed;
    const float m_enemyBulletSpeed;
    const float m_backgroundSpeed;
    float m_enemyChanceNotToShoot;

    // Control flags
    bool m_shoot;
    bool m_moveUp;
    bool m_moveDown;
    bool m_moveLeft;
    bool m_moveRight;

    // Set resolution based on settings
    void setResolution(Resolution::Setting resolution);
    // Set difficulty level of the game
    void setDifficulty(Difficulty::Level difficulty);
    void initializeStatusTextView();
    void updateStatusTextView();

    void loadTextures();
    void loadCarTextures(std::vector<sf::Texture>& textures, const std::string& basePath, int count);
    bool loadHighScores();
    void saveNewHighscore();
    void restart();
    void initLifeIndicators();
    void playerMovement();

    void spawnPlayer();
    void spawnEnemies();

    bool isOutOfScreen(const sf::FloatRect& rect) const;
    void handleInput();
    void updateMovement();
    void updateState();
    void destroyObjects();
    void render();
};
