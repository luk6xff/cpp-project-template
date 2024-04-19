#include "GameCar.h"

#include "Collision/Collision.h"

#include <cmath>

GameCar::GameCar(CarType type, Team team, float scale, const sf::Texture& texture, const sf::Texture& bulletTexture)
    : Animation(texture)
    , m_team(team)
    , m_scaleMultiplier(scale)
{
    m_bulletSprite.setTexture(bulletTexture);
    initializeCar(type);
}

bool GameCar::isDead() const
{
    return m_isDestroyed;
};

void GameCar::setHealth(int health)
{
    m_health      = health;
    m_isDestroyed = (m_health <= 0);
}

int GameCar::getDamage() const
{
    return m_damage;
}

void GameCar::damage(int amount)
{
    if (!m_isDestroyed)
    {
        m_health -= amount;
        if (m_health <= 0)
        {
            m_isDestroyed = true;
        }
    }
}

std::vector<sf::Sprite> GameCar::fireBullets()
{
    sf::Time elapsed = m_clock.getElapsedTime();
    std::vector<sf::Sprite> bullets;

    if (elapsed.asMilliseconds() - m_lastShotTime >= m_msBetweenShots)
    {
        sf::FloatRect bulletRect = m_bulletSprite.getGlobalBounds();
        sf::Vector2f carPosition = getPosition();

        for (const auto& pos : m_shootingPositions)
        {
            m_bulletSprite.setPosition(
                carPosition.x + pos.x - bulletRect.width / 2,
                carPosition.y + pos.y - bulletRect.height);
            bullets.push_back(m_bulletSprite);
        }

        m_lastShotTime = elapsed.asMilliseconds();
    }

    return bullets;
}

void GameCar::initializeCar(CarType type)
{
    m_carType = type;
    switch (type)
    {
        case CarType::Truck:
            initializeTruck();
            break;
        case CarType::Car:
            initializeCar();
            break;
    }
}

void GameCar::setScale(float scaleX, float scaleY)
{
    Animation::setScale(scaleX, scaleY);
    for (sf::Vector2f& pos : m_shootingPositions)
    {
        pos.x *= scaleX;
        pos.y *= scaleY;
    }
}

bool GameCar::isCollidedWith(const sf::Sprite& other)
{
    if (getRect().intersects(other.getGlobalBounds()))
    {
        return Collision::pixelPerfectTest(m_frames[0], other);
    }
    return false;
}

void GameCar::moveAIWithinBounds(int maxX, float speed)
{
    sf::FloatRect carRect = getRect();

    if (m_destination == -1)
    {
        m_destination         = std::rand() % static_cast<int>(maxX - carRect.width);
        m_destinationGreaterX = m_destination >= carRect.left;
    }

    if (m_destinationGreaterX)
    {
        move(speed, 0);
    }
    else
    {
        move(-speed, 0);
    }

    if (m_destinationGreaterX != (m_destination >= carRect.left))
    {
        m_destination = -1;
    }
}

void GameCar::addShootingPosition(float x, float y)
{
    m_shootingPositions.emplace_back(x * m_scaleMultiplier, y * m_scaleMultiplier);
}

void GameCar::setFiringRate(int milliseconds)
{
    m_msBetweenShots = milliseconds;
}

CarType GameCar::getCarType() const
{
    return m_carType;
}

void GameCar::configureBullet(float scaleX, float scaleY)
{
    m_bulletSprite.setScale(scaleX, scaleY);
}

void GameCar::initializeCar()
{
    addShootingPosition(120, 0);
    setMsBetweenFrames(60);
    setFiringRate(100);
    m_damage = 2;
    setScale(0.2 * m_scaleMultiplier, 0.2 * m_scaleMultiplier);
    configureBullet(0.3 * m_scaleMultiplier, 0.35 * m_scaleMultiplier);
    m_health = 15;
}

void GameCar::initializeTruck()
{
    addShootingPosition(40, 200);
    addShootingPosition(340, 200);
    setMsBetweenFrames(40);
    setFiringRate(80);
    m_damage = 1;
    setScale(0.4 * m_scaleMultiplier, 0.4 * m_scaleMultiplier);
    configureBullet(0.45 * m_scaleMultiplier, 0.45 * m_scaleMultiplier);
    m_health = 20;
}
