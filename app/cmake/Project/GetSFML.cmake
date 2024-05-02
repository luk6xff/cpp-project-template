# Fetch SFML libs
include(FetchContent)

FetchContent_Declare(
    SFML
    GIT_REPOSITORY https://github.com/SFML/SFML.git
    GIT_TAG 2.6.x
)

option(BUILD_SHARED_LIBS "Build shared libraries" OFF)

FetchContent_MakeAvailable(SFML)
