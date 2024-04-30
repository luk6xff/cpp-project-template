# Include libraries
include(GetSFML)

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
    Game/GameCar.cpp
    Game/ExecutablePath.cpp
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


#install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX})
#install(DIRECTORY ${CMAKE_SOURCE_DIR}/assets/ DESTINATION ${CMAKE_INSTALL_PREFIX}/assets) LU_TODO: Fix this
#file(COPY ${CMAKE_SOURCE_DIR}/assets/ DESTINATION {CMAKE_INSTALL_PREFIX}/assets)
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
            ${CMAKE_SOURCE_DIR}/assets
            ${CMAKE_INSTALL_PREFIX}/assets
    COMMENT "Copying assets to build directory"
)



# Clang format
include(ClangFormat)
Format(${PROJECT_NAME} .)

