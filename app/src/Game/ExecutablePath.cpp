#include <filesystem>
#include <iostream>
#include <limits.h> // for PATH_MAX
#include <unistd.h>

namespace executable_path {
namespace fs = std::filesystem;

// Function to get the executable path as a filesystem path
fs::path getExecutablePath() {
  char result[PATH_MAX];
  ssize_t count = readlink("/proc/self/exe", result, PATH_MAX);
  if (count > 0) {
    return fs::path(std::string(result, count));
  }
  // Return an empty path if the readlink fails
  return fs::path();
}

// Function to get the directory containing the executable as a filesystem path
fs::path getExecutableDirPath() {
  fs::path execDirPath = getExecutablePath();
  return execDirPath.parent_path();
}

} // namespace executable_path
