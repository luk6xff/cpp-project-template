#include "Game.h"

#include <cmath>
#include <profiler.h>

Game::Game(const std::filesystem::path &execDirPath,
           Resolution::Setting resolutionSetting,
           Difficulty::Level gameDifficulty)
    : m_execDirPath(execDirPath), m_timePerFrame(sf::seconds(1.f / 60.f)),
      m_delta(m_timePerFrame.asSeconds()), m_highScores({0, 0, 0}),
      m_lifeScale(0.07f), m_score(0), m_maxPlayerHealth(5),
      m_playerSpeed(420.f), m_enemyCarSpeed(210.f), m_enemyTruckSpeed(170.f),
      m_playerBulletSpeed(600.f), m_enemyBulletSpeed(300.f),
      m_backgroundSpeed(1200.f), m_enemyChanceNotToShoot(6.5f), m_shoot(false),
      m_moveUp(false), m_moveDown(false), m_moveLeft(false),
      m_moveRight(false) {
  setResolution(resolutionSetting);
  setDifficulty(gameDifficulty);
  initializeStatusTextView();
  loadHighScores();
  loadTextures();
  restart();

  sf::VideoMode desktop = sf::VideoMode::getDesktopMode();
  m_window.create(sf::VideoMode(m_screenWidth, m_screenHeight),
                  "Volvo Cars Shooter", sf::Style::Close);
  m_window.setPosition(sf::Vector2i((desktop.width - m_screenWidth) / 2,
                                    (desktop.height - m_screenHeight) / 2));
  m_window.setFramerateLimit(60);
}

///////////////////////////////////////////////////////////////////////////////
// Public methods
///////////////////////////////////////////////////////////////////////////////
void Game::run() {
  sf::Clock clock;
  sf::Time timeSinceLastUpdate = sf::Time::Zero;

  while (m_window.isOpen() && m_isRunning) {
    sf::Time elapsedTime = clock.restart();
    timeSinceLastUpdate += elapsedTime;

    while (timeSinceLastUpdate > m_timePerFrame) {
      timeSinceLastUpdate -= m_timePerFrame;
      EASY_BLOCK("handleInput()", profiler::colors::Red);
      handleInput();
      EASY_END_BLOCK;
      EASY_BLOCK("updateMovement()", profiler::colors::Blue);
      updateMovement();
      EASY_END_BLOCK;
      EASY_BLOCK("updateState()", profiler::colors::Green);
      updateState();
      EASY_END_BLOCK;
      EASY_BLOCK("destroyObjects()", profiler::colors::Orange);
      destroyObjects();
      EASY_END_BLOCK;
    }

    render();
  }
}

///////////////////////////////////////////////////////////////////////////////
// Private methods
///////////////////////////////////////////////////////////////////////////////
void Game::setResolution(Resolution::Setting resolution) {
  auto dimensions = Resolution::getIntFromResolution(resolution);
  m_screenHeight = dimensions.first;
  m_screenWidth = dimensions.second;
  m_window.setSize(sf::Vector2u(m_screenHeight, m_screenWidth));
  m_window.setView(
      sf::View(sf::FloatRect(0, 0, m_screenHeight, m_screenWidth)));
}

void Game::setDifficulty(Difficulty::Level difficulty) {
  m_difficulty = difficulty;
  // Adjust game parameters based on difficulty
  switch (m_difficulty) {
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

void Game::initializeStatusTextView() {
  if (!m_font.loadFromFile(m_execDirPath / m_execDirPath /
                           "assets/fonts/Jersey25-Regular.ttf")) {
    std::cerr << "Failed to load font." << std::endl;
  }

  m_scoreText.setFont(m_font);
  m_scoreText.setCharacterSize(32);
  m_scoreText.setFillColor(sf::Color::Red);

  m_highScoreText.setFont(m_font);
  m_highScoreText.setCharacterSize(32);
  m_highScoreText.setFillColor(sf::Color::Red);

  m_timeText.setFont(m_font);
  m_timeText.setCharacterSize(24);
  m_timeText.setFillColor(sf::Color::Red);

  m_restartText.setFont(m_font);
  m_restartText.setCharacterSize(64);
  m_restartText.setFillColor(sf::Color::Red);
  m_restartText.setString("Press R to restart");
  sf::FloatRect restartBounds = m_restartText.getLocalBounds();
  m_restartText.setPosition((m_screenWidth - restartBounds.width) / 2,
                            (m_screenHeight - restartBounds.height) / 2);

  updateStatusTextView();
}

void Game::updateStatusTextView() {
  // Data
  m_scoreText.setString("Score: " + std::to_string(m_score));
  m_highScoreText.setString(
      "High Score: " +
      std::to_string(m_highScores[static_cast<int>(m_difficulty)]));

  // Positions
  m_scoreText.setPosition(10, 5);
  sf::FloatRect highScoreBounds = m_highScoreText.getLocalBounds();
  m_highScoreText.setPosition(m_screenWidth - highScoreBounds.width - 10, 5);
}

void Game::handleInput() {
  sf::Event event;
  while (m_window.pollEvent(event)) {
    if (event.type == sf::Event::Closed) {
      m_window.close();
    } else if (event.type == sf::Event::KeyPressed) {
      switch (event.key.code) {
      case sf::Keyboard::Escape:
        m_window.close();
        break;
      case sf::Keyboard::R:
        restart();
        break;
      case sf::Keyboard::Space:
        m_shoot = true;
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
      default:
        break;
      }
    } else if (event.type == sf::Event::KeyReleased) {
      switch (event.key.code) {
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
      default:
        break;
      }
    }
  }
}

void Game::updateMovement() {
  if (m_background) {
    m_background->moveDown(m_backgroundSpeed * m_delta);
  }
  playerMovement();
  for (auto &enemy : m_enemies) {
    enemy.moveAIWithinBounds(m_screenWidth,
                             (enemy.getCarType() == CarType::Truck
                                  ? m_enemyTruckSpeed
                                  : m_enemyCarSpeed) *
                                 m_delta);
  }
  for (auto &bullet : m_playerBullets) {
    bullet.move(0, -m_playerBulletSpeed * m_delta);
  }
  for (auto &bullet : m_enemyBullets) {
    bullet.move(0, m_enemyBulletSpeed * m_delta);
  }
}

void Game::updateState() {
  if (!m_player->isDead()) {
    if (m_shoot) {
      std::vector<sf::Sprite> bullets = m_player->fireBullets();
      m_playerBullets.insert(m_playerBullets.end(), bullets.begin(),
                             bullets.end());
    }
    for (auto &enemy : m_enemies) {
      if (rand() % 100 < 1) {
        std::vector<sf::Sprite> bullets = enemy.fireBullets();
        m_enemyBullets.insert(m_enemyBullets.end(), bullets.begin(),
                              bullets.end());
      }
    }
  }

  for (auto bulletIt = m_playerBullets.begin();
       bulletIt != m_playerBullets.end(); ++bulletIt) {
    for (auto &enemy : m_enemies) {
      if (enemy.isCollidedWith(*bulletIt)) {
        enemy.damage(m_player->getDamage());
        enemy.flash(sf::Color::Blue, 30);
        bulletIt = m_playerBullets.erase(bulletIt);
        bulletIt--;
        break;
      }
    }
  }

  for (auto bulletIt = m_enemyBullets.begin(); bulletIt != m_enemyBullets.end();
       ++bulletIt) {
    if (m_player->isCollidedWith(*bulletIt)) {
      m_player->damage(1);
      m_player->flash(sf::Color::Red, 80);
      bulletIt = m_enemyBullets.erase(bulletIt);
      if (m_lives.size() > 0) {
        m_lives.pop_back();
      }
      bulletIt--;
    }
  }

  // Check if it's time to spawn new enemies
  if (m_enemies.empty()) {
    m_enemyCount++;
    spawnEnemies();
  }
  updateStatusTextView();
}

void Game::destroyObjects() {
  m_playerBullets.erase(
      std::remove_if(m_playerBullets.begin(), m_playerBullets.end(),
                     [this](const sf::Sprite &bullet) {
                       return isOutOfScreen(bullet.getGlobalBounds());
                     }),
      m_playerBullets.end());

  m_enemyBullets.erase(
      std::remove_if(m_enemyBullets.begin(), m_enemyBullets.end(),
                     [this](const sf::Sprite &bullet) {
                       return isOutOfScreen(bullet.getGlobalBounds());
                     }),
      m_enemyBullets.end());

  m_enemies.erase(
      std::remove_if(m_enemies.begin(), m_enemies.end(),
                     [this](const GameCar &car) {
                       if (car.isDead()) {
                         m_score += car.getDamage();
                         m_explosions.push_back(
                             ExplosionEffect{m_enemyExplosionTextures});
                         m_explosions.back().setPosition(car.getPosition().x,
                                                         car.getPosition().y);
                         m_explosions.back().setMsBetweenFrames(1000 / 60);
                         m_explosions.back().play();
                       }
                       return car.isDead();
                     }),
      m_enemies.end());

  if (m_player->isDead() && m_player->isInvisible() == false) {
    const sf::Vector2f playerPos = m_player->getPosition();
    m_player->toggleInvisibility();

    m_explosions.push_back(ExplosionEffect{m_playerExplosionTextures});
    m_explosions.back().setPosition(playerPos.x, playerPos.y);
    m_explosions.back().setMsBetweenFrames(1000 / 60);
    m_explosions.back().play();

    // Update score text and highscore
    if (m_score > m_highScores[static_cast<int>(m_difficulty)]) {
      m_highScores[static_cast<int>(m_difficulty)] = m_score;
      saveNewHighscore();
    }
    updateStatusTextView();
  }
}

void Game::render() {
  m_window.clear();
  if (m_background) {
    m_background->draw(m_window);
  }
  for (const auto &bullet : m_playerBullets) {
    m_window.draw(bullet);
  }
  for (const auto &bullet : m_enemyBullets) {
    m_window.draw(bullet);
  }
  if (!m_player->isDead()) {
    m_player->draw(m_window);
  }
  for (auto &enemy : m_enemies) {
    enemy.draw(m_window);
  }
  for (auto &explosion : m_explosions) {
    explosion.drawNext(m_window);
  }
  for (const auto &life : m_lives) {
    m_window.draw(life);
  }
  if (m_player->isDead()) {
    m_window.draw(m_restartText);
    m_window.draw(m_scoreText);
    m_window.draw(m_timeText);
    m_window.draw(m_highScoreText);
  } else {
    m_window.draw(m_scoreText);
    m_window.draw(m_timeText);
    m_window.draw(m_highScoreText);
  }

  m_window.display();
}

bool Game::isOutOfScreen(const sf::FloatRect &rect) const {
  return rect.left + rect.width < 0 || rect.left > m_screenWidth ||
         rect.top + rect.height < 0 || rect.top > m_screenHeight;
}

void Game::loadTextures() {
  if (!m_backgroundTexture.loadFromFile(m_execDirPath /
                                        "assets/sprites/background.png")) {
    std::cerr << "Failed to load background "
                 "texture."
              << std::endl;
  }
  m_background = std::make_unique<Background>(m_backgroundTexture,
                                              m_screenWidth, m_screenHeight);

  if (!m_playerBulletTexture.loadFromFile(m_execDirPath /
                                          "assets/sprites/player_bullet.bmp")) {
    std::cerr << "Failed to load player "
                 "bullet texture."
              << std::endl;
  }

  if (!m_enemyBulletTexture.loadFromFile(m_execDirPath /
                                         "assets/sprites/enemy_bullet.bmp")) {
    std::cerr << "Failed to load enemy "
                 "bullet texture."
              << std::endl;
  }

  if (!m_playerLifeTexture.loadFromFile(m_execDirPath /
                                        "assets/sprites/life.png")) {
    std::cerr << "Failed to load life texture." << std::endl;
  }

  if (!m_playerCarTexture.loadFromFile(m_execDirPath /
                                       "assets/sprites/player_car.png")) {
    std::cerr << "Failed to load player car "
                 "texture."
              << std::endl;
  }

  // Load enemy textures
  loadCarTextures(m_enemyCarTextures, m_execDirPath / "assets/sprites/car_", 4);
  loadCarTextures(m_enemyTruckTextures, m_execDirPath / "assets/sprites/truck_",
                  1);

  // Load explosion textures
  loadCarTextures(m_enemyExplosionTextures,
                  m_execDirPath / "assets/sprites/enemy_explosion_", 13);
  loadCarTextures(m_playerExplosionTextures,
                  m_execDirPath / "assets/sprites/player_explosion_", 13);
}

void Game::loadCarTextures(std::vector<sf::Texture> &textures,
                           const std::string &basePath, int count) {
  textures.clear();
  for (int i = 0; i < count; ++i) {
    sf::Texture texture;
    std::string path = basePath + std::to_string(i) + ".png";
    if (!texture.loadFromFile(path)) {
      std::cerr << "Failed to load texture from " << path << std::endl;
    } else {
      textures.push_back(texture);
    }
  }
}

// Load high scores from a file
bool Game::loadHighScores() {
  std::ifstream scoresFile(m_execDirPath / "results.bin", std::ios::binary);
  if (!scoresFile) {
    std::cerr << "Failed to open high scores file." << std::endl;
    return false;
  }
  scoresFile.read(reinterpret_cast<char *>(m_highScores.data()),
                  sizeof(m_highScores));
  return scoresFile.good();
}

// Save high scores to a file
void Game::saveNewHighscore() {
  std::ofstream scoresFile(m_execDirPath / "results.bin",
                           std::ios::binary | std::ios::trunc);
  if (!scoresFile) {
    std::cerr << "Failed to write high scores file." << std::endl;
    return;
  }
  scoresFile.write(reinterpret_cast<const char *>(m_highScores.data()),
                   sizeof(m_highScores));
}

// Reset game to initial state
void Game::restart() {
  m_score = 0;
  m_enemyCount = 0;
  m_enemies.clear();
  m_playerBullets.clear();
  m_enemyBullets.clear();

  spawnPlayer();
  spawnEnemies();
  initLifeIndicators();

  m_playTimeClock.restart();
}

// Initialize life indicators based on player
// health
void Game::initLifeIndicators() {
  m_lives.clear();
  for (int i = 0; i < m_maxPlayerHealth; ++i) {
    sf::Sprite life(m_playerLifeTexture);
    life.setScale(m_lifeScale, m_lifeScale);
    int x = life.getGlobalBounds().width * i;
    int y = m_screenHeight - life.getGlobalBounds().height;
    life.setPosition(x, y);
    m_lives.push_back(life);
  }
}

// Handle player movement based on input
void Game::playerMovement() {
  if (m_moveLeft)
    m_player->move(-m_playerSpeed * m_delta, 0);
  if (m_moveRight)
    m_player->move(m_playerSpeed * m_delta, 0);
  if (m_moveUp)
    m_player->move(0, -m_playerSpeed * m_delta);
  if (m_moveDown)
    m_player->move(0, m_playerSpeed * m_delta);
}

// Initialize the player
void Game::spawnPlayer() {
  m_player =
      std::make_unique<GameCar>(CarType::Car, GameCar::Team::Player, 0.3f,
                                m_playerCarTexture, m_playerBulletTexture);
  const sf::FloatRect playerRect = m_player->getRect();
  m_player->setPosition((m_screenWidth / 2 - playerRect.width / 2),
                        m_screenHeight - playerRect.height);
  m_player->setHealth(m_maxPlayerHealth);
}

// Spawn enemies on the screen
void Game::spawnEnemies() {

  // Spawn as many enemies as enemyCount
  for (int i = 0; i < m_enemyCount; i++) {
    int randNum = rand() % 100;

    // 20% chance for the enemy to be an truck
    if (randNum < 20) {
      m_enemies.push_back(
          GameCar{CarType::Truck, GameCar::Team::Enemy, 0.4f,
                  m_enemyTruckTextures[randNum % (m_enemyTruckTextures.size())],
                  m_enemyBulletTexture});
    } else {
      m_enemies.push_back(
          GameCar{CarType::Car, GameCar::Team::Enemy, 0.3f,
                  m_enemyCarTextures[randNum % (m_enemyCarTextures.size())],
                  m_enemyBulletTexture});
    }
    // Set position
    const auto y =
        static_cast<uint32_t>(rand() % 2 * m_enemies.back().getRect().height) %
        (m_screenHeight / 3U);
    const auto x = rand() % static_cast<int>(m_screenWidth -
                                             m_enemies.back().getRect().width);
    m_enemies.back().setPosition(x, y);

    m_enemies.back().setFiringRate(500);
  }
}
