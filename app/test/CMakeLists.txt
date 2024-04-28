cmake_minimum_required(VERSION 3.22)
project(MyProjectTests LANGUAGES CXX)

# enable_testing()

# # Include GoogleTest fetched in the main CMakeLists.txt
# include(FetchContent)
# FetchContent_Declare(
#   googletest
#   URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
# )
# # For Windows: Prevent overriding the parent project's compiler/linker settings
# set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
# FetchContent_MakeAvailable(googletest)

add_subdirectory(unit)
#add_subdirectory(integration)
#add_subdirectory(functional)
