# Fethc SFML libs
option(BUILD_SHARED_LIBS "Build shared libraries" OFF)
include(FetchContent)
FetchContent_Declare(SFML
    GIT_REPOSITORY https://github.com/SFML/SFML.git
    GIT_TAG 2.6.x)
FetchContent_MakeAvailable(SFML)

# Include directories
include_directories(
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/thirdparty
)

# List of source files
set(SOURCE_FILES
    main.cpp
    Configuration/ConfigReader.cpp
    Configuration/Resolution.cpp
    Configuration/Difficulty.cpp
    Animation/Animation.cpp
    Animation/ExplosionEffect.cpp
    Background/Background.cpp
    GameCar/GameCar.cpp
    Game/Game.cpp
)

add_executable(
    ${PROJECT_NAME}
    ${SOURCE_FILES}
)

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE
    # Common libraries
    Collision
    EasyProfiler
    # Project specific libraries
    sfml-graphics
    sfml-system
    sfml-window
    sfml-audio
)

target_compile_features(
    ${PROJECT_NAME}
    PRIVATE cxx_std_17
)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)

# Clang format
include(ClangFormat)
Format(${PROJECT_NAME} .)

# CppCheck
# include(CppCheck)
# AddCppCheck(${PROJECT_NAME})

# Generate doxygen documentation
include(Doxygen)
Doxygen(${PROJECT_NAME} docs)
