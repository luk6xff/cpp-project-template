#pragma once

#include "Animation/Animation.h"

#include <array>
#include <functional>
#include <vector>

/**
 * @enum CarType
 * @brief Enumerates the types of cars available
 * in the game.
 */
enum class CarType { Car, Truck };

/**
 * @class GameCar
 * @brief Represents a car in the game, extending
 * the Animation class.
 *
 * GameCar handles car-specific functionalities
 * including movement, firing bullets, collision
 * detection, and health management.
 */
class GameCar : public Animation {
public:
  /**
   * @enum Team
   * @brief Identifies the team to which the
   * GameCar belongs.
   */
  enum class Team { Player, Enemy };

  /**
   * @brief Constructor for creating a new
   * GameCar instance.
   * @param type The type of the car (Car or
   * Truck).
   * @param team The team of the car (Player or
   * Enemy).
   * @param scale The scale multiplier for the
   * car's size.
   * @param textures Reference to the car's
   * texture.
   * @param bulletTexture Reference to the
   * texture used for the car's bullets.
   */
  GameCar(CarType type, Team team, float scale, const sf::Texture &textures,
          const sf::Texture &bulletTexture);

  /**
   * @brief Default virtual destructor.
   */
  virtual ~GameCar() = default;

  /**
   * @brief Inflicts damage to the car.
   * @param amount The amount of damage to
   * inflict.
   */
  void damage(int amount);

  /**
   * @brief Retrieves the damage value of the
   * car.
   * @return The damage amount the car can
   * inflict.
   */
  int getDamage() const;

  /**
   * @brief Checks if the car is destroyed.
   * @return True if the car is dead, false
   * otherwise.
   */
  bool isDead() const;

  /**
   * @brief Sets the health of the car.
   * @param health The new health value.
   */
  void setHealth(int health);

  /**
   * @brief Configures the dimensions of bullets
   * fired by the car.
   * @param scaleX The scale factor along the
   * X-axis.
   * @param scaleY The scale factor along the
   * Y-axis.
   */
  void configureBullet(float scale);

  /**
   * @brief Sets the firing rate of the car.
   * @param milliseconds The interval in
   * milliseconds between shots.
   */
  void setFiringRate(int milliseconds);

  /**
   * @brief Fires bullets from all configured
   * shooting positions.
   * @return A vector of sprites representing
   * the bullets fired.
   */
  std::vector<sf::Sprite> fireBullets();

  /**
   * @brief Moves the car within game boundaries
   * with the given speed.
   * @param maxX The maximum X boundary of the
   * game area.
   * @param speed The speed of the car.
   */
  void moveAIWithinBounds(int maxX, float speed);

  /**
   * @brief Checks if this car has collided with
   * another sprite.
   * @param other The other sprite to check
   * collision against.
   * @return True if there is a collision, false
   * otherwise.
   */
  bool isCollidedWith(const sf::Sprite &other);

  /**
   * @brief Retrieves the car type.
   * @return The type of the car (Car or Truck).
   */
  CarType getCarType() const;

private:
  Team m_team;                ///< The team of the car.
  float m_scaleMultiplier;    ///< Scale multiplier
                              ///< for size
                              ///< adjustments.
  CarType m_carType;          ///< The type of the car.
  int m_destination = -1;     ///< Destination for AI movement.
  bool m_destinationGreaterX; ///< Flag
                              ///< indicating
                              ///< movement
                              ///< towards a
                              ///< greater X
                              ///< value.

  sf::Sprite m_bulletSprite;        ///< Sprite used
                                    ///< for bullets.
  sf::Int32 m_lastShotTime = -1000; ///< Time since the last shot.
  int m_msBetweenShots = 1;         ///< Milliseconds between each shot.

  int m_health = 20;          ///< Health of the car.
  int m_damage = 1;           ///< Damage the car can inflict.
  bool m_isDestroyed = false; ///< Flag indicating if the car is
                              ///< destroyed.

  void initializeCar();
  void initializeTruck();
  void initializeCar(CarType type);
};
