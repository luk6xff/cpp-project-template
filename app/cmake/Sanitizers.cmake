# Function to check and enable sanitizer options
function(enable_sanitizers target)
    # List of sanitizer options
    set(SANITIZER_OPTIONS
        ASAN  # Address Sanitizer
        TSAN  # Thread Sanitizer
        UBSAN # Undefined Behavior Sanitizer
        MSAN  # Memory Sanitizer
    )

    # Track active sanitizers to prevent incompatible combinations
    set(active_sanitizers "")

    # Check the selected compiler
    if("${COMPILER_CHOICE}" STREQUAL "CLANG")
        set(USING_CLANG ON)
    else()
        set(USING_CLANG OFF)
    endif()

    foreach(_SAN IN LISTS SANITIZER_OPTIONS)
        string(TOUPPER ${_SAN} _SAN_UPPER)
        if(${_SAN_UPPER})  # Check if the option was passed to CMake
            message(STATUS "Enabling ${_SAN} for ${target}")

            # Handling different sanitizers
            if("${_SAN_UPPER}" STREQUAL "ASAN")
                if("MSAN" IN_LIST active_sanitizers)
                    message(FATAL_ERROR "ASAN and MSAN cannot be used together.")
                endif()
                if("TSAN" IN_LIST active_sanitizers)
                    message(FATAL_ERROR "ASAN and TSAN cannot be used together.")
                endif()
                target_compile_options(${target} PRIVATE -fsanitize=address)
                target_link_options(${target} PRIVATE -fsanitize=address)
                list(APPEND active_sanitizers "ASAN")
            elseif("${_SAN_UPPER}" STREQUAL "TSAN")
                if("ASAN" IN_LIST active_sanitizers)
                    message(FATAL_ERROR "TSAN and ASAN cannot be used together.")
                endif()
                target_compile_options(${target} PRIVATE -fsanitize=thread)
                target_link_options(${target} PRIVATE -fsanitize=thread)
            elseif("${_SAN_UPPER}" STREQUAL "UBSAN")
                target_compile_options(${target} PRIVATE -fsanitize=undefined)
                target_link_options(${target} PRIVATE -fsanitize=undefined)
            elseif("${_SAN_UPPER}" STREQUAL "MSAN")
                if("ASAN" IN_LIST active_sanitizers)
                    message(FATAL_ERROR "MSAN and ASAN cannot be used together.")
                endif()
                if(USING_CLANG)
                    target_compile_options(${target} PRIVATE -fsanitize=memory)
                    target_link_options(${target} PRIVATE -fsanitize=memory)
                else()
                    message(WARNING "MemorySanitizer is only supported by Clang. Skipping MSAN for ${target}.")
                endif()
                list(APPEND active_sanitizers "MSAN")
            endif()
        endif()
    endforeach()
endfunction()
