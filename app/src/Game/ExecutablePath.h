#include <filesystem>
#include <iostream>
#include <limits.h> // for PATH_MAX
#include <unistd.h>

namespace executable_path
{
namespace fs = std::filesystem;
fs::path getExecutablePath();
fs::path getExecutableDirPath();
} // namespace executable_path
