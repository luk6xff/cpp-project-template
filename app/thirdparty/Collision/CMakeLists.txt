# Set the project name
project (Collision)

set(SOURCES
    "Collision.cpp"
)

add_library(
    ${PROJECT_NAME}
    STATIC
    ${SOURCES}
)

target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

include(FetchContent)
FetchContent_Declare(SFML
    GIT_REPOSITORY https://github.com/SFML/SFML.git
    GIT_TAG 2.6.x)
FetchContent_MakeAvailable(SFML)

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE
    sfml-graphics
    sfml-system
    sfml-window
    sfml-audio
)
