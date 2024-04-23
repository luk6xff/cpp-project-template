set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(COMPILE_COMMANDS_FILE ${CMAKE_BINARY_DIR}/compile_commands.json)
set(FILTERED_COMPILE_COMMANDS_FILE ${CMAKE_BINARY_DIR}/filtered_compile_commands.json)

set(PYTHON_SCRIPT_PATH "${CMAKE_SOURCE_DIR}/utils/filter_compile_commands.py")

# Define a list of directories to exclude
set(EXCLUSION_DIRS "thirdparty" "_deps")

# Construct the Python command
set(PYTHON_CMD "python ${PYTHON_SCRIPT_PATH} ${COMPILE_COMMANDS_FILE} ${FILTERED_COMPILE_COMMANDS_FILE}")

# Append each exclusion directory as a separate argument
foreach(DIR IN LISTS EXCLUSION_DIRS)
    set(PYTHON_CMD "${PYTHON_CMD} ${DIR}")
endforeach()


add_custom_command(
    OUTPUT ${FILTERED_COMPILE_COMMANDS_FILE}
    COMMAND ${CMAKE_COMMAND} -E echo "Filtering compile commands to exclude specified directories..."
    COMMAND sh -c "${PYTHON_CMD}"
    DEPENDS ${COMPILE_COMMANDS_FILE}
    COMMENT "Generating filtered compile commands."
    VERBATIM
)

add_custom_target(
    filter_compile_commands
    DEPENDS ${FILTERED_COMPILE_COMMANDS_FILE}
    COMMENT "Filtered compile commands available at ${FILTERED_COMPILE_COMMANDS_FILE}"
)

