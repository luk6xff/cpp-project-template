#include "GameCar.h"

#include "Collision/Collision.h"

#include <cmath>
#include <iostream>

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

        const sf::FloatRect rect = getRect();
        m_bulletSprite.setPosition(carPosition.x + rect.width / 2.0f, carPosition.y + bulletRect.height);
        bullets.push_back(m_bulletSprite);

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

void GameCar::setFiringRate(int milliseconds)
{
    m_msBetweenShots = milliseconds;
}

CarType GameCar::getCarType() const
{
    return m_carType;
}

void GameCar::configureBullet(float scale)
{
    m_bulletSprite.setScale(scale, scale);
}

void GameCar::initializeCar()
{
    setMsBetweenFrames(60);
    setFiringRate(100);
    m_damage = 2;
    setScale(m_scaleMultiplier, m_scaleMultiplier);
    configureBullet(m_scaleMultiplier);
    m_health = 15;
}

void GameCar::initializeTruck()
{
    setMsBetweenFrames(60);
    setFiringRate(80);
    m_damage = 5;
    setScale(1.2f * m_scaleMultiplier, 1.2f * m_scaleMultiplier);
    configureBullet(1.2f * m_scaleMultiplier);
    m_health = 30;
}
