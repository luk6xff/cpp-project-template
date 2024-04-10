cmake_minimum_required(VERSION 3.22)
project(MyProjectTests LANGUAGES CXX)

enable_testing()

# Include GoogleTest fetched in the main CMakeLists.txt
include(FetchContent)
FetchContent_MakeAvailable(googletest)

add_subdirectory(unit)
add_subdirectory(integration)
add_subdirectory(functional)
