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

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE
    sfml-graphics
)
