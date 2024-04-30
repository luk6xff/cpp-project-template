#include "Configuration/Resolution.h"

#include <gtest/gtest.h>

class ResolutionTest : public ::testing::Test {
protected:
  void SetUp() override {}
  void TearDown() override {}
};

// Test for converting strings to Resolution::Setting enum values
TEST_F(ResolutionTest, StringToSettingValid) {
  auto res600x800 = Resolution::stringToResolution("600x800");
  auto res768x1024 = Resolution::stringToResolution("768x1024");
  auto res864x1152 = Resolution::stringToResolution("864x1152");
  auto res960x1280 = Resolution::stringToResolution("960x1280");

  EXPECT_TRUE(res600x800.has_value());
  EXPECT_EQ(Resolution::Setting::h600w800, res600x800.value());

  EXPECT_TRUE(res768x1024.has_value());
  EXPECT_EQ(Resolution::Setting::h768w1024, res768x1024.value());

  EXPECT_TRUE(res864x1152.has_value());
  EXPECT_EQ(Resolution::Setting::h864w1152, res864x1152.value());

  EXPECT_TRUE(res960x1280.has_value());
  EXPECT_EQ(Resolution::Setting::h960w1280, res960x1280.value());
}

// Test for invalid string input
TEST_F(ResolutionTest, StringToSettingInvalid) {
  auto invalid = Resolution::stringToResolution("1000x1000");
  EXPECT_FALSE(invalid.has_value());
}

// Test for converting Resolution::Setting enum values to strings
TEST_F(ResolutionTest, SettingToString) {
  std::string str600x800 =
      Resolution::resolutionToStr(Resolution::Setting::h600w800);
  std::string str768x1024 =
      Resolution::resolutionToStr(Resolution::Setting::h768w1024);
  std::string str864x1152 =
      Resolution::resolutionToStr(Resolution::Setting::h864w1152);
  std::string str960x1280 =
      Resolution::resolutionToStr(Resolution::Setting::h960w1280);

  EXPECT_EQ("600x800", str600x800);
  EXPECT_EQ("768x1024", str768x1024);
  EXPECT_EQ("864x1152", str864x1152);
  EXPECT_EQ("960x1280", str960x1280);
}

// Test for getting resolution dimensions from Setting enum values
TEST_F(ResolutionTest, GetIntFromResolution) {
  auto res600x800 =
      Resolution::getIntFromResolution(Resolution::Setting::h600w800);
  auto res768x1024 =
      Resolution::getIntFromResolution(Resolution::Setting::h768w1024);
  auto res864x1152 =
      Resolution::getIntFromResolution(Resolution::Setting::h864w1152);
  auto res960x1280 =
      Resolution::getIntFromResolution(Resolution::Setting::h960w1280);

  EXPECT_EQ(std::make_pair(600U, 800U), res600x800);
  EXPECT_EQ(std::make_pair(768U, 1024U), res768x1024);
  EXPECT_EQ(std::make_pair(864U, 1152U), res864x1152);
  EXPECT_EQ(std::make_pair(960U, 1280U), res960x1280);
}
