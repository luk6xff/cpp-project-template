#include "Animation.h"

Animation::Animation(const std::vector<sf::Texture>& textures, bool isLooping)
    : m_isLooping(isLooping)
{
    for (const auto& texture : textures)
    {
        sf::Sprite temp;
        temp.setTexture(texture);
        m_frames.push_back(std::move(temp));
    }
    m_playing = !m_isLooping; // Start stopped if looping,
                              // play immediately if not
}

Animation::Animation(const sf::Texture& texture, bool isLooping)
    : m_isLooping(isLooping)
{
    sf::Sprite temp;
    temp.setTexture(texture);
    m_frames.push_back(std::move(temp));
    m_playing = !m_isLooping; // Start stopped if looping,
                              // play immediately if not
}

void Animation::play()
{
    m_playing      = true;
    m_currentFrame = 0;
    m_clock.restart(); // Restart the clock when
                       // starting the animation
}

void Animation::stop()
{
    m_playing = false;
}

void Animation::switchTextures(const std::vector<sf::Texture>& textures)
{
    auto pos = getPosition();
    m_frames.clear();

    for (const auto& texture : textures)
    {
        sf::Sprite temp;
        temp.setTexture(texture);
        temp.setPosition(pos);
        m_frames.push_back(std::move(temp));
    }
}

void Animation::toggleInvisibility()
{
    sf::Color newColor = m_invisible ? sf::Color::White : sf::Color{255, 255, 255, 0};
    for (auto& frame : m_frames)
    {
        frame.setColor(newColor);
    }
    m_invisible = !m_invisible;
}

bool Animation::isInvisible() const
{
    return m_invisible;
}

int Animation::draw(sf::RenderWindow& window)
{
    if (m_firstDraw)
    {
        m_clock.restart();
        m_firstDraw = false;
    }

    sf::Int32 elapsedTime = m_clock.getElapsedTime().asMilliseconds();
    size_t frameIndex     = (elapsedTime / m_msBetweenFrames) % m_frames.size();

    if (m_flashMsDuration && (m_flashStart + m_flashMsDuration >= elapsedTime))
    {
        m_frames[frameIndex].setColor(m_flashColor);
        window.draw(m_frames[frameIndex]);
        m_frames[frameIndex].setColor(sf::Color::White);
    }
    else
    {
        window.draw(m_frames[frameIndex]);
    }

    return frameIndex;
}

void Animation::flash(sf::Color color, int durationMs)
{
    m_flashColor      = color;
    m_flashMsDuration = durationMs;
    m_flashStart      = m_clock.getElapsedTime().asMilliseconds();
}

void Animation::move(float offsetX, float offsetY)
{
    for (auto& frame : m_frames)
    {
        frame.move(offsetX, offsetY);
    }
}

void Animation::moveUp(float speed, int minY)
{
    auto rect = getRect();
    if (rect.top - speed >= minY)
    {
        setPosition(rect.left, rect.top - speed);
    }
}

void Animation::moveDown(float speed, int maxY)
{
    auto rect = getRect();
    if (rect.top + rect.height + speed <= maxY)
    {
        setPosition(rect.left, rect.top + speed);
    }
}

void Animation::moveLeft(float speed, int minX)
{
    auto rect = getRect();
    if (rect.left - speed >= minX)
    {
        setPosition(rect.left - speed, rect.top);
    }
}

void Animation::moveRight(float speed, int maxX)
{
    auto rect = getRect();
    if (rect.left + rect.width + speed <= maxX)
    {
        setPosition(rect.left + speed, rect.top);
    }
}

void Animation::setMsBetweenFrames(int ms)
{
    m_msBetweenFrames = ms;
}

void Animation::setScale(float scaleX, float scaleY)
{
    for (auto& frame : m_frames)
    {
        frame.setScale(scaleX, scaleY);
    }
}

void Animation::setPosition(float x, float y)
{
    for (auto& frame : m_frames)
    {
        frame.setPosition(x, y);
    }
}

sf::Vector2f Animation::getScale() const
{
    return m_frames.front().getScale();
}

sf::Vector2f Animation::getPosition() const
{
    return m_frames.front().getPosition();
}

sf::FloatRect Animation::getRect() const
{
    return m_frames.front().getGlobalBounds();
}

class ExplosionEffect : public Animation
{
protected:
    sf::Int32 lastTimeDrawn = 0;
    bool playing            = false;
    uint32_t currentFrame   = 0;

public:
    ExplosionEffect(std::vector<sf::Texture>& textures)
        : Animation(textures)
    {
    }

    void play();
    bool isPlaying();
    void drawNext(sf::RenderWindow& window);
    virtual ~ExplosionEffect()
    {
    }
};
