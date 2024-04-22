# Infer.cmake
cmake_minimum_required(VERSION 3.10)

find_program(INFER_EXECUTABLE NAMES infer)
if(NOT INFER_EXECUTABLE)
    message(FATAL_ERROR "Infer not found! Please install Infer or check your PATH.")
endif()

# Ensure compile_commands.json will be generated
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Path for Infer output
set(INFER_OUTPUT_DIR ${CMAKE_BINARY_DIR}/infer-out)

# Ensure the output directory exists
add_custom_command(
    OUTPUT ${INFER_OUTPUT_DIR}
    COMMAND ${CMAKE_COMMAND} -E echo "Preparing Infer analysis..."
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${INFER_OUTPUT_DIR}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${INFER_OUTPUT_DIR}
    COMMENT "Setting up Infer output directory"
    VERBATIM
)

# Custom target to run Infer
add_custom_target(infer ALL
    COMMAND ${CMAKE_COMMAND} -E echo "Running Infer capture..."
    COMMAND ${INFER_EXECUTABLE} capture --reactive --continue --compilation-database ${CMAKE_BINARY_DIR}/compile_commands.json
    COMMAND ${CMAKE_COMMAND} -E echo "Running Infer analyze..."
    COMMAND ${INFER_EXECUTABLE} analyze --results-dir ${INFER_OUTPUT_DIR}
    DEPENDS ${INFER_OUTPUT_DIR}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Infer static analysis is running..."
)

# Optionally add this analysis as part of the project build
add_dependencies(${PROJECT_NAME} infer)
