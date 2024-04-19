#include "Game.h"

#include <cmath>

Game::Game(Resolution::Setting resolutionSetting, Difficulty::Level gameDifficulty)
    : m_timePerFrame(sf::seconds(1.f / 60.f))
    , m_delta(m_timePerFrame.asSeconds())
    , m_lifeScale(0.07f)
    , m_textScale(2.0f)
    , m_maxPlayerHealth(5)
    , m_playerSpeed(420.f)
    , m_enemyCarSpeed(210.f)
    , m_enemyTruckSpeed(170.f)
    , m_playerBulletSpeed(600.f)
    , m_enemyBulletSpeed(300.f)
    , m_backgroundSpeed(1200.f)
    , m_enemyChanceNotToShoot(6.5f)
    , m_moveDown(false)
    , m_moveLeft(false)
    , m_moveRight(false)
    , m_moveUp(false)
{
    setResolution(resolutionSetting);
    setDifficulty(gameDifficulty);
    statusTextView();
    loadHighScores();
    loadTextures();
    initPlayer();
    initLifeIndicators();

    sf::VideoMode desktop = sf::VideoMode::getDesktopMode();
    m_window.create(sf::VideoMode(m_screenWidth, m_screenHeight), "Cars Shooter", sf::Style::Close);
    m_window.setPosition(sf::Vector2i((desktop.width - m_screenWidth) / 2, (desktop.height - m_screenHeight) / 2));
    m_window.setFramerateLimit(60);
}

void Game::run()
{
    sf::Clock clock;
    sf::Time timeSinceLastUpdate = sf::Time::Zero;

    while (m_window.isOpen() && m_isRunning)
    {
        sf::Time elapsedTime = clock.restart();
        timeSinceLastUpdate += elapsedTime;

        while (timeSinceLastUpdate > m_timePerFrame)
        {
            timeSinceLastUpdate -= m_timePerFrame;
            handleInput();
            updateMovement();
            updateActions();
            destroyObjects();
        }

        render();
    }
}

void Game::handleInput()
{
    sf::Event event;
    while (m_window.pollEvent(event))
    {
        if (event.type == sf::Event::Closed)
        {
            m_window.close();
        }
        else if (event.type == sf::Event::KeyPressed)
        {
            switch (event.key.code)
            {
                case sf::Keyboard::Escape:
                case sf::Keyboard::Q:
                    m_window.close();
                    break;
                case sf::Keyboard::R:
                    restart();
                    break;
                case sf::Keyboard::Space:
                    m_shoot = true;
                    break;
                case sf::Keyboard::G:
                    m_shootToggle = !m_shootToggle;
                    break;
                case sf::Keyboard::W:
                case sf::Keyboard::Up:
                    m_moveUp = true;
                    break;
                case sf::Keyboard::S:
                case sf::Keyboard::Down:
                    m_moveDown = true;
                    break;
                case sf::Keyboard::A:
                case sf::Keyboard::Left:
                    m_moveLeft = true;
                    break;
                case sf::Keyboard::D:
                case sf::Keyboard::Right:
                    m_moveRight = true;
                    break;
            }
        }
        else if (event.type == sf::Event::KeyReleased)
        {
            switch (event.key.code)
            {
                case sf::Keyboard::Space:
                    m_shoot = false;
                    break;
                case sf::Keyboard::W:
                case sf::Keyboard::Up:
                    m_moveUp = false;
                    break;
                case sf::Keyboard::S:
                case sf::Keyboard::Down:
                    m_moveDown = false;
                    break;
                case sf::Keyboard::A:
                case sf::Keyboard::Left:
                    m_moveLeft = false;
                    break;
                case sf::Keyboard::D:
                case sf::Keyboard::Right:
                    m_moveRight = false;
                    break;
            }
        }
    }
}

void Game::updateMovement()
{
    if (m_background)
    {
        m_background->moveDown(m_backgroundSpeed * m_delta);
    }
    playerMovement();
    for (auto& enemy : m_enemies)
    {
        enemy.moveAIWithinBounds(
            m_screenWidth,
            (enemy.getCarType() == CarType::Truck ? m_enemyTruckSpeed : m_enemyCarSpeed) * m_delta);
    }
    for (auto& bullet : m_playerBullets)
    {
        bullet.move(0, -m_playerBulletSpeed * m_delta);
    }
    for (auto& bullet : m_enemyBullets)
    {
        bullet.move(0, m_enemyBulletSpeed * m_delta);
    }
}

void Game::updateActions()
{
    if (!m_player->isDead())
    {
        if (m_shoot || m_shootToggle)
        {
            std::vector<sf::Sprite> bullets = m_player->fireBullets();
            m_playerBullets.insert(m_playerBullets.end(), bullets.begin(), bullets.end());
        }
        for (auto& enemy : m_enemies)
        {
            if (rand() % 100 < 1)
            {
                std::vector<sf::Sprite> bullets = enemy.fireBullets();
                m_enemyBullets.insert(m_enemyBullets.end(), bullets.begin(), bullets.end());
            }
        }
    }

    for (auto bulletIt = m_playerBullets.begin(); bulletIt != m_playerBullets.end(); ++bulletIt)
    {
        for (auto& enemy : m_enemies)
        {
            if (enemy.isCollidedWith(*bulletIt))
            {
                enemy.damage(m_player->getDamage());
                enemy.flash(sf::Color::Blue, 30);
                bulletIt = m_playerBullets.erase(bulletIt);
                bulletIt--;
                break;
            }
        }
    }

    for (auto bulletIt = m_enemyBullets.begin(); bulletIt != m_enemyBullets.end(); ++bulletIt)
    {
        if (m_player->isCollidedWith(*bulletIt))
        {
            m_player->damage(1);
            m_player->flash(sf::Color::Red, 80);
            bulletIt = m_enemyBullets.erase(bulletIt);
            m_lives.pop_back();
            bulletIt--;
        }
    }

    // Check if it's time to spawn new enemies
    if (m_enemies.empty())
    {
        m_enemyCount++;
        spawnEnemies();
    }
}

void Game::destroyObjects()
{
    m_playerBullets.erase(
        std::remove_if(
            m_playerBullets.begin(),
            m_playerBullets.end(),
            [this](const sf::Sprite& bullet)
            {
                return isOutOfScreen(bullet.getGlobalBounds());
            }),
        m_playerBullets.end());

    m_enemyBullets.erase(
        std::remove_if(
            m_enemyBullets.begin(),
            m_enemyBullets.end(),
            [this](const sf::Sprite& bullet)
            {
                return isOutOfScreen(bullet.getGlobalBounds());
            }),
        m_enemyBullets.end());

    m_enemies.erase(
        std::remove_if(
            m_enemies.begin(),
            m_enemies.end(),
            [this](const GameCar& car)
            {
                return car.isDead();
            }),
        m_enemies.end());

    if (m_player->isDead() && m_player->isInvisible() == false)
    {
        sf::Vector2f playerPos = m_player->getPosition();
        m_player->toggleInvisibility();

        // placing explosion effect
        playerPos.x -= 20 * (m_screenWidth / 1024);
        m_explosions.push_back(ExplosionEffect{m_playerExplosionTextures});
        m_explosions.back().setPosition(playerPos.x, playerPos.y);
        m_explosions.back().setMsBetweenFrames(1000 / 60);
        m_explosions.back().play();

        // Update score text and highscore
        updateStatusTextView();
    }
}

void Game::render()
{
    m_window.clear();
    if (m_background)
    {
        m_background->draw(m_window);
    }
    for (const auto& bullet : m_playerBullets)
    {
        m_window.draw(bullet);
    }
    for (const auto& bullet : m_enemyBullets)
    {
        m_window.draw(bullet);
    }
    if (!m_player->isDead())
    {
        m_player->draw(m_window);
    }
    for (auto& enemy : m_enemies)
    {
        enemy.draw(m_window);
    }
    for (auto& explosion : m_explosions)
    {
        explosion.draw(m_window);
    }
    for (const auto& life : m_lives)
    {
        m_window.draw(life);
    }
    if (m_player->isDead())
    {
        m_window.draw(m_restartText);
        m_window.draw(m_scoreText);
        m_window.draw(m_timeText);
        m_window.draw(m_highScoreText);
    }
    m_window.display();
}

bool Game::isOutOfScreen(const sf::FloatRect& rect) const
{
    return rect.left + rect.width < 0 || rect.left > m_screenWidth || rect.top + rect.height < 0 ||
           rect.top > m_screenHeight;
}

void Game::loadTextures()
{
    if (!m_backgroundTexture.loadFromFile("media/background.png"))
    {
        std::cerr << "Failed to load background "
                     "texture."
                  << std::endl;
    }
    m_background = std::make_unique<Background>(m_backgroundTexture, m_screenWidth, m_screenHeight);

    if (!m_playerBulletTexture.loadFromFile("media/player_bullet.bmp"))
    {
        std::cerr << "Failed to load player "
                     "bullet texture."
                  << std::endl;
    }

    if (!m_enemyBulletTexture.loadFromFile("media/enemy_bullet.bmp"))
    {
        std::cerr << "Failed to load enemy "
                     "bullet texture."
                  << std::endl;
    }

    if (!m_playerLifeTexture.loadFromFile("media/life.png"))
    {
        std::cerr << "Failed to load life texture." << std::endl;
    }

    if (!m_playerCarTexture.loadFromFile("media/player_car.png"))
    {
        std::cerr << "Failed to load player car "
                     "texture."
                  << std::endl;
    }

    // Load enemy textures
    loadCarTextures(m_enemyCarTextures, "media/car_", 3);
    loadCarTextures(m_enemyTruckTextures, "media/truck_", 1);

    // Load explosion textures
    loadCarTextures(m_enemyExplosionTextures, "media/enemy_explosion_", 12);
    loadCarTextures(m_playerExplosionTextures, "media/player_explosion_", 12);
}

void Game::loadCarTextures(std::vector<sf::Texture>& textures, const std::string& basePath, int count)
{
    textures.clear();
    for (int i = 0; i < count; ++i)
    {
        sf::Texture texture;
        std::string path = basePath + std::to_string(i + 1) + ".png";
        if (!texture.loadFromFile(path))
        {
            std::cerr << "Failed to load texture from " << path << std::endl;
        }
        else
        {
            textures.push_back(texture);
        }
    }
}

// Load high scores from a file
bool Game::loadHighScores()
{
    std::ifstream scoresFile("results.bin", std::ios::binary);
    if (!scoresFile)
    {
        std::cerr << "Failed to open high scores file." << std::endl;
        return false;
    }
    scoresFile.read(reinterpret_cast<char*>(m_highScores.data()), sizeof(m_highScores));
    return scoresFile.good();
}

// Save high scores to a file
void Game::saveNewHighscore()
{
    std::ofstream scoresFile("results.bin", std::ios::binary | std::ios::trunc);
    if (!scoresFile)
    {
        std::cerr << "Failed to write high scores file." << std::endl;
        return;
    }
    scoresFile.write(reinterpret_cast<const char*>(m_highScores.data()), sizeof(m_highScores));
}

// Update the score and high score texts
void Game::updateStatusTextView()
{
    m_scoreText.setString("Score: " + std::to_string(m_score));
    m_highScoreText.setString("High Score: " + std::to_string(m_highScores[static_cast<int>(m_difficulty)]));

    // Position the score text at the top center
    // of the screen
    sf::FloatRect scoreBounds = m_scoreText.getLocalBounds();
    m_scoreText.setPosition((m_screenWidth - scoreBounds.width) / 2, 20);

    // Position the high score text just below the
    // score text
    sf::FloatRect highScoreBounds = m_highScoreText.getLocalBounds();
    m_highScoreText.setPosition((m_screenWidth - highScoreBounds.width) / 2, 50);
}

// Reset game to initial state
void Game::restart()
{
    m_score      = 0;
    m_enemyCount = 0;
    m_enemies.clear();
    m_playerBullets.clear();
    m_enemyBullets.clear();
    initLifeIndicators();

    sf::FloatRect playerRect = m_player->getRect();
    if (m_player->isInvisible())
        m_player->toggleInvisibility();
    m_player->setHealth(m_maxPlayerHealth);
    m_player->setPosition((m_screenWidth / 2) - (playerRect.width / 2), m_screenHeight - playerRect.height);

    m_playTimeClock.restart();
}

// Initialize life indicators based on player
// health
void Game::initLifeIndicators()
{
    m_lives.clear();
    for (int i = 0; i < m_maxPlayerHealth; ++i)
    {
        sf::Sprite life(m_playerLifeTexture);
        life.setScale(m_lifeScale, m_lifeScale);
        int x = life.getGlobalBounds().width * i;
        int y = m_screenHeight - life.getGlobalBounds().height;
        life.setPosition(x, y);
        m_lives.push_back(life);
    }
}

// Handle player movement based on input
void Game::playerMovement()
{
    if (m_moveLeft)
        m_player->move(-m_playerSpeed * m_delta, 0);
    if (m_moveRight)
        m_player->move(m_playerSpeed * m_delta, 0);
    if (m_moveUp)
        m_player->move(0, -m_playerSpeed * m_delta);
    if (m_moveDown)
        m_player->move(0, m_playerSpeed * m_delta);
}

// Initialize text elements
void Game::statusTextView()
{
    m_scoreText.setCharacterSize(24);
    m_scoreText.setFillColor(sf::Color::Green);

    m_highScoreText.setCharacterSize(24);
    m_highScoreText.setFillColor(sf::Color::Green);

    m_timeText.setCharacterSize(24);
    m_timeText.setFillColor(sf::Color::Green);
}

// Initialize the player
void Game::initPlayer()
{
    m_player = std::make_unique<GameCar>(
        CarType::Car,
        GameCar::Team::Player,
        (float)m_screenWidth / 800,
        m_playerCarTexture,
        m_playerBulletTexture);
    m_player->setPosition(
        (m_screenWidth / 2.0f) - m_player->getRect().width / 2,
        m_screenHeight - m_player->getRect().height);
    m_player->setHealth(m_maxPlayerHealth);
}

// Set resolution based on settings
void Game::setResolution(Resolution::Setting resolution)
{
    auto dimensions = Resolution::getIntFromResolution(resolution);
    m_screenHeight  = dimensions.first;
    m_screenWidth   = dimensions.second;
    m_window.setSize(sf::Vector2u(m_screenWidth, m_screenHeight));
    m_window.setView(sf::View(sf::FloatRect(0, 0, m_screenWidth, m_screenHeight)));
}

// Set difficulty level of the game
void Game::setDifficulty(Difficulty::Level difficulty)
{
    m_difficulty = difficulty;
    // Adjust game parameters based on difficulty
    switch (m_difficulty)
    {
        case Difficulty::Level::Easy:
            m_enemyChanceNotToShoot = 15.0f;
            break;
        case Difficulty::Level::Normal:
            m_enemyChanceNotToShoot = 10.0f;
            break;
        case Difficulty::Level::Hard:
            m_enemyChanceNotToShoot = 5.0f;
            break;
    }
}

// Spawn enemies on the screen
void Game::spawnEnemies()
{
    // Spawn as many enemies as enemyCount
    for (int i = 0; i < m_enemyCount; i++)
    {
        int randNum = rand() % 100;

        // 20% chance for the enemy to be an truck
        if (randNum < 20)
        {
            m_enemies.push_back(GameCar{
                CarType::Truck,
                GameCar::Team::Enemy,
                (float)m_screenWidth / 800,
                m_enemyTruckTextures[randNum % (m_enemyTruckTextures.size())],
                m_enemyBulletTexture});
        }
        else
        {
            m_enemies.push_back(GameCar{
                CarType::Car,
                GameCar::Team::Enemy,
                (float)m_screenWidth / 800,
                m_enemyCarTextures[randNum % (m_enemyCarTextures.size())],
                m_enemyBulletTexture});
        }
        // Set position
        int y = (rand() % 2) * m_enemies.back().getRect().height;
        int x = rand() % (int)(m_screenWidth - m_enemies.back().getRect().width);
        m_enemies.back().setPosition(x, y);

        m_enemies.back().setFiringRate(500);
    }
}