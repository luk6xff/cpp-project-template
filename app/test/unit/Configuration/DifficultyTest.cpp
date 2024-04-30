#include "Configuration/Difficulty.h"

#include <gtest/gtest.h>

class DifficultyTest : public ::testing::Test {
protected:
  void SetUp() override {}

  void TearDown() override {}
};

TEST_F(DifficultyTest, StringToDifficultyValid) {
  auto easy = Difficulty::stringToDifficulty("easy");
  auto normal = Difficulty::stringToDifficulty("normal");
  auto hard = Difficulty::stringToDifficulty("hard");

  EXPECT_TRUE(easy.has_value());
  EXPECT_EQ(Difficulty::Level::Easy, easy.value());

  EXPECT_TRUE(normal.has_value());
  EXPECT_EQ(Difficulty::Level::Normal, normal.value());

  EXPECT_TRUE(hard.has_value());
  EXPECT_EQ(Difficulty::Level::Hard, hard.value());
}

TEST_F(DifficultyTest, StringToDifficultyInvalid) {
  auto invalid = Difficulty::stringToDifficulty("invalid");
  EXPECT_FALSE(invalid.has_value());
}

TEST_F(DifficultyTest, DifficultyToString) {
  std::string easyStr = Difficulty::difficultyToString(Difficulty::Level::Easy);
  std::string normalStr =
      Difficulty::difficultyToString(Difficulty::Level::Normal);
  std::string hardStr = Difficulty::difficultyToString(Difficulty::Level::Hard);

  EXPECT_EQ("easy", easyStr);
  EXPECT_EQ("normal", normalStr);
  EXPECT_EQ("hard", hardStr);
}
