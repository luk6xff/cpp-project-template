#include "Configuration/ConfigReader.h"

#include <gmock/gmock.h>
#include <gtest/gtest.h>

using ::testing::_;
using ::testing::ByMove;
using ::testing::Invoke;
using ::testing::NiceMock;
using ::testing::Return;

class MockFileStreamFactory : public IFileStreamFactory
{
public:
    MOCK_METHOD(std::unique_ptr<std::istream>, createInputStream, (const std::string& path), (const, override));
    MOCK_METHOD(std::unique_ptr<std::ostream>, createOutputStream, (const std::string& path), (const, override));
};

class MockInputStream : public std::istringstream
{
public:
    MockInputStream(const std::string& s)
        : std::istringstream(s)
    {
    }
};

class ConfigReaderTest : public ::testing::Test
{
protected:
    NiceMock<MockFileStreamFactory> mockFileStreamFactory;
    std::string dummyConfigPath = "dummyConfig.txt";
};

TEST_F(ConfigReaderTest, LoadSettingsFromFile_ValidSettings_CallsParseCorrectly)
{
    MockInputStream* mockInput = new MockInputStream("#Configuration File\nresolution 960x1280\ndifficulty hard\n");
    Resolution::Setting res;
    Difficulty::Level dif;

    EXPECT_CALL(mockFileStreamFactory, createInputStream(_))
        .WillOnce(Return(ByMove(std::unique_ptr<std::istringstream>(mockInput))));

    ConfigReader reader(dummyConfigPath, mockFileStreamFactory);
    reader.loadSettingsFromFile(res, dif);

    ASSERT_EQ(res, Resolution::Setting::h960w1280);
    ASSERT_EQ(dif, Difficulty::Level::Hard);
}

TEST_F(ConfigReaderTest, LoadSettingsFromFile_MixedValidInvalidSettings_HandlesCorrectly)
{
    MockInputStream* mockInput =
        new MockInputStream("#Configuration File\nresolution 960x1280\ninvalid entry\ndifficulty hard\n");
    Resolution::Setting res;
    Difficulty::Level dif;

    EXPECT_CALL(mockFileStreamFactory, createInputStream(_))
        .WillOnce(Return(ByMove(std::unique_ptr<std::istringstream>(mockInput))));

    ConfigReader reader(dummyConfigPath, mockFileStreamFactory);
    reader.loadSettingsFromFile(res, dif);

    ASSERT_EQ(res, Resolution::Setting::h600w800); // Resolution::Setting::h960w1280); - Call unit test failure
    ASSERT_EQ(dif, Difficulty::Level::Hard);
}
