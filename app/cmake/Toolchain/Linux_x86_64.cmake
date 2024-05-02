# ################################################################################
# # CMAKE Toolchain for linux x86_64
# #
# # Specify toolchain file in cmake generation via:
# # cmake -DCMAKE_TOOLCHAIN_FILE=Toolchain/Linux_x86_64.cmake -DCOMPILER_CHOICE=GCC -DDebug
# #
# # Author: Lukasz Uszko <lukasz.uszko@gmail.com>
# ################################################################################

# include(CMakeForceCompiler)
# set(CMAKE_C_COMPILER_WORKS 1)
# set(CMAKE_CXX_COMPILER_WORKS 1)

# set(CMAKE_SYSTEM_NAME Linux)
# set(CMAKE_SYSTEM_PROCESSOR x86_64)
# add_definitions("-DLINUX")
# add_definitions("-D__linux__")
# set(TOOLCHAIN "Linux x86_64")

# # Compiler selection
# set(COMPILER_CHOICE "GCC" CACHE STRING "Select the compiler: GCC or Clang")
# set_property(CACHE COMPILER_CHOICE PROPERTY STRINGS "GCC" "Clang")

# # Set compiler common flags
# # Clang flags
# set(COMPILER_CLANG_CXXFLAGS
#     -Werror
#     -Weverything
# )
# # GCC flags
# set(COMPILER_GCC_CXXFLAGS
#     -pedantic
#     -Werror
#     --all-warnings
#     --extra-warnings
#     -W
#     -WNSObject-attribute
#     -Waddress
#     -Waddress-of-packed-member
#     -Waggressive-loop-optimizations
#     -Waligned-new=all
#     -Wall
#     -Walloc-zero
#     -Walloca
#     -Wanalyzer-double-fclose
#     -Wanalyzer-double-free
#     -Wanalyzer-exposure-through-output-file
#     -Wanalyzer-file-leak
#     -Wanalyzer-free-of-non-heap
#     -Wanalyzer-malloc-leak
#     -Wanalyzer-mismatching-deallocation
#     -Wanalyzer-null-argument
#     -Wanalyzer-null-dereference
#     -Wanalyzer-possible-null-argument
#     -Wanalyzer-possible-null-dereference
#     -Wanalyzer-shift-count-negative
#     -Wanalyzer-shift-count-overflow
#     -Wanalyzer-stale-setjmp-buffer
#     -Wanalyzer-tainted-allocation-size
#     -Wanalyzer-tainted-array-index
#     -Wanalyzer-tainted-divisor
#     -Wanalyzer-tainted-offset
#     -Wanalyzer-tainted-size
#     -Wanalyzer-too-complex
#     -Wanalyzer-unsafe-call-within-signal-handler
#     -Wanalyzer-use-after-free
#     -Wanalyzer-use-of-pointer-in-stale-stack-frame
#     -Wanalyzer-use-of-uninitialized-value
#     -Wanalyzer-va-arg-type-mismatch
#     -Wanalyzer-va-list-exhausted
#     -Wanalyzer-va-list-leak
#     -Wanalyzer-va-list-use-after-va-end
#     -Wanalyzer-write-to-const
#     -Wanalyzer-write-to-string-literal
#     -Warith-conversion
#     -Warray-bounds=2
#     -Warray-compare
#     -Warray-parameter=2
#     -Wattribute-alias=2
#     -Wattribute-warning
#     -Wattributes
#     -Wbool-compare
#     -Wbool-operation
#     -Wbuiltin-declaration-mismatch
#     -Wbuiltin-macro-redefined
#     -Wc++0x-compat
#     -Wc++11-compat
#     -Wc++11-extensions
#     -Wc++14-compat
#     -Wc++14-extensions
#     -Wc++17-compat
#     -Wc++17-extensions
#     -Wc++1z-compat
#     -Wc++20-compat
#     -Wc++20-extensions
#     -Wc++23-extensions
#     -Wc++2a-compat
#     -Wcannot-profile
#     -Wcast-align
#     -Wcast-align=strict
#     -Wcast-function-type
#     -Wcast-qual
#     -Wcatch-value=3
#     -Wchar-subscripts
#     -Wclass-conversion
#     -Wclass-memaccess
#     -Wclobbered
#     -Wcomma-subscript
#     -Wcomment
#     -Wcomments
#     -Wconditionally-supported
#     -Wconversion
#     -Wconversion-null
#     -Wcoverage-invalid-line-number
#     -Wcoverage-mismatch
#     -Wcpp
#     -Wctad-maybe-unsupported
#     -Wctor-dtor-privacy
#     -Wdangling-else
#     -Wdangling-pointer=2
#     -Wdate-time
#     -Wdelete-incomplete
#     -Wdelete-non-virtual-dtor
#     -Wdeprecated
#     -Wdeprecated-copy
#     -Wdeprecated-copy-dtor
#     -Wdeprecated-declarations
#     -Wdeprecated-enum-enum-conversion
#     -Wdeprecated-enum-float-conversion
#     -Wdisabled-optimization
#     -Wdiv-by-zero
#     -Wdouble-promotion
#     -Wduplicated-branches
#     -Wduplicated-cond
#     -Weffc++
#     -Wempty-body
#     -Wendif-labels
#     -Wenum-compare
#     -Wenum-conversion
#     -Wexceptions
#     -Wexpansion-to-defined
#     -Wextra
#     -Wextra-semi
#     -Wfloat-conversion
#     -Wfloat-equal
#     -Wformat-diag
#     -Wformat-overflow=2
#     -Wformat-signedness
#     -Wformat-truncation=2
#     -Wformat=2
#     -Wframe-address
#     -Wfree-nonheap-object
#     -Whsa
#     -Wif-not-aligned
#     -Wignored-attributes
#     -Wignored-qualifiers
#     -Wimplicit-fallthrough=5
#     -Winaccessible-base
#     -Winfinite-recursion
#     -Winherited-variadic-ctor
#     -Winit-list-lifetime
#     -Winit-self
#     -Winline
#     -Wint-in-bool-context
#     -Wint-to-pointer-cast
#     -Winterference-size
#     -Winvalid-imported-macros
#     -Winvalid-memory-model
#     -Winvalid-offsetof
#     -Winvalid-pch
#     -Wliteral-suffix
#     -Wlogical-not-parentheses
#     -Wlogical-op
#     -Wlto-type-mismatch
#     -Wmain
#     -Wmaybe-uninitialized
#     -Wmemset-elt-size
#     -Wmemset-transposed-args
#     -Wmisleading-indentation
#     -Wmismatched-dealloc
#     -Wmismatched-new-delete
#     -Wmismatched-tags
#     -Wmissing-attributes
#     -Wmissing-braces
#     -Wmissing-declarations
#     -Wmissing-field-initializers
#     -Wmissing-include-dirs
#     -Wmissing-profile
#     -Wmissing-requires
#     -Wmissing-template-keyword
#     -Wmultichar
#     -Wmultiple-inheritance
#     -Wmultistatement-macros
#     -Wnarrowing
#     -Wnull-dereference
#     -Wodr
#     -Wold-style-cast
#     -Wopenacc-parallelism
#     -Wopenmp-simd
#     -Woverflow
#     -Woverlength-strings
#     -Woverloaded-virtual
#     -Wpacked
#     -Wpacked-bitfield-compat
#     -Wpacked-not-aligned
#     -Wparentheses
#     -Wpedantic
#     -Wpessimizing-move
#     -Wplacement-new=2
#     -Wpmf-conversions
#     -Wpointer-arith
#     -Wpointer-compare
#     -Wpragmas
#     -Wprio-ctor-dtor
#     -Wpsabi
#     -Wrange-loop-construct
#     -Wredundant-decls
#     -Wredundant-move
#     -Wredundant-tags
#     -Wregister
#     -Wreorder
#     -Wrestrict
#     -Wreturn-local-addr
#     -Wreturn-type
#     -Wscalar-storage-order
#     -Wsequence-point
#     -Wshadow=compatible-local
#     -Wshadow=global
#     -Wshadow=local
#     -Wshift-count-negative
#     -Wshift-count-overflow
#     -Wshift-negative-value
#     -Wshift-overflow=2
#     -Wsign-compare
#     -Wsign-conversion
#     -Wsign-promo
#     -Wsized-deallocation
#     -Wsizeof-array-argument
#     -Wsizeof-array-div
#     -Wsizeof-pointer-div
#     -Wsizeof-pointer-memaccess
#     -Wstack-protector
#     -Wstrict-aliasing=3
#     -Wstrict-null-sentinel
#     -Wstring-compare
#     -Wstringop-overflow=4
#     -Wstringop-overread
#     -Wstringop-truncation
#     -Wsubobject-linkage
#     -Wsuggest-attribute=cold
#     -Wsuggest-attribute=const
#     -Wsuggest-attribute=format
#     -Wsuggest-attribute=malloc
#     -Wsuggest-attribute=noreturn
#     -Wsuggest-attribute=pure
#     -Wsuggest-final-methods
#     -Wsuggest-final-types
#     -Wsuggest-override
#     -Wswitch
#     -Wswitch-bool
#     -Wswitch-default
#     -Wswitch-enum
#     -Wswitch-outside-range
#     -Wswitch-unreachable
#     -Wsync-nand
#     -Wsynth
#     -Wtautological-compare
#     -Wterminate
#     -Wtrampolines
#     -Wtrigraphs
#     -Wtrivial-auto-var-init
#     -Wtsan
#     -Wtype-limits
#     -Wundef
#     -Wuninitialized
#     -Wunknown-pragmas
#     -Wunreachable-code
#     -Wunsafe-loop-optimizations
#     -Wunused
#     -Wunused-but-set-parameter
#     -Wunused-but-set-variable
#     -Wunused-const-variable=2
#     -Wunused-function
#     -Wunused-label
#     -Wunused-local-typedefs
#     -Wunused-macros
#     -Wunused-parameter
#     -Wunused-result
#     -Wunused-value
#     -Wunused-variable
#     -Wuse-after-free=3
#     -Wuseless-cast
#     -Wvarargs
#     -Wvariadic-macros
#     -Wvector-operation-performance
#     -Wvexing-parse
#     -Wvirtual-inheritance
#     -Wvirtual-move-assign
#     -Wvla
#     -Wvla-parameter
#     -Wvolatile
#     -Wvolatile-register-var
#     -Wwrite-strings
#     -Wzero-as-null-pointer-constant
#     -Wzero-length-bounds
# )

# if (COMPILER_CHOICE STREQUAL "GCC")
#     set(CMAKE_C_COMPILER /usr/bin/gcc)
#     set(CMAKE_CXX_COMPILER /usr/bin/g++)
#     set(COMMON_FLAGS "${COMPILER_GCC_CXXFLAGS}")
# elseif (COMPILER_CHOICE STREQUAL "Clang")
#     set(CMAKE_C_COMPILER /usr/bin/clang)
#     set(CMAKE_CXX_COMPILER /usr/bin/clang++)
#     set(COMMON_FLAGS "${COMPILER_CLANG_CXXFLAGS}")
# else()
#     message(FATAL_ERROR "Invalid compiler choice: ${COMPILER_CHOICE}. Please select GCC or Clang.")
# endif()


# set(COMMON_FLAGS "${COMMON_FLAGS} -Wno-variadic-macros -Wpedantic -Wshadow -Wformat-truncation -finline-functions -Wall -Wextra -Werror -Wfatal-errors")

# if(CMAKE_BUILD_TYPE STREQUAL "Debug")
#     set(COMMON_FLAGS "${COMMON_FLAGS} -O0 -g")
#     if (COMPILER_CHOICE STREQUAL "GCC")
#         set(COVERAGE_COMPILE_FLAGS "-fprofile-arcs -ftest-coverage")
#         set(COVERAGE_LINK_FLAGS "-lgcov -fprofile-arcs -ftest-coverage")
#     elseif(COMPILER_CHOICE STREQUAL "Clang")
#         set(COVERAGE_COMPILE_FLAGS "--coverage")
#         set(COVERAGE_LINK_FLAGS "--coverage")
#     endif()
# elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
#     set(COMMON_FLAGS "${COMMON_FLAGS} -O3")
# endif()

# set(COMMON_FLAGS "${COMMON_FLAGS} ${COVERAGE_COMPILE_FLAGS}")
# set(CMAKE_CXX_FLAGS_INIT "${COMMON_FLAGS}")
# set(CMAKE_C_FLAGS_INIT "${COMMON_FLAGS}")

# set(CMAKE_POSITION_INDEPENDENT_CODE ON)
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_INIT}")
# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${COVERAGE_LINK_FLAGS}")
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_INIT}")






################################################################################
# CMAKE Toolchain for Linux x86_64
#
# Specify toolchain file in cmake generation via:
# cmake -DCMAKE_TOOLCHAIN_FILE=Toolchain/Linux_x86_64.cmake -DCOMPILER_CHOICE=GCC -DDebug
#
# Author: Lukasz Uszko <lukasz.uszko@gmail.com>
################################################################################

include(CMakeForceCompiler)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
add_definitions("-DLINUX")
add_definitions("-D__linux__")
set(TOOLCHAIN "Linux x86_64")

# Compiler selection
set(COMPILER_CHOICE "GCC" CACHE STRING "Select the compiler: GCC or CLANG")
set_property(CACHE COMPILER_CHOICE PROPERTY STRINGS "GCC" "CLANG")

if (COMPILER_CHOICE STREQUAL "GCC")
    set(CMAKE_C_COMPILER /usr/bin/gcc)
    set(CMAKE_CXX_COMPILER /usr/bin/g++)
    # Define GCC-specific flags here
    set(COMPILER_SPECIFIC_FLAGS "-Wall -Wextra -pedantic -Werror -Wno-variadic-macros -Wshadow -Wformat-truncation -finline-functions")
elseif (COMPILER_CHOICE STREQUAL "CLANG")
    set(CMAKE_C_COMPILER /usr/bin/clang)
    set(CMAKE_CXX_COMPILER /usr/bin/clang++)
    # Define Clang-specific flags here
    set(COMPILER_SPECIFIC_FLAGS "-Wall -Wextra -Weverything -Werror -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-covered-switch-default -Wno-global-constructors -Wno-weak-vtables")
else()
    message(FATAL_ERROR "Invalid compiler choice: ${COMPILER_CHOICE}. Please select GCC or CLANG.")
endif()

# Coverage flags
set(COVERAGE_COMPILE_FLAGS "")
set(COVERAGE_LINK_FLAGS "")

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(COMPILER_SPECIFIC_FLAGS "${COMPILER_SPECIFIC_FLAGS} -O0 -g")
    if (COMPILER_CHOICE STREQUAL "GCC")
      set(COVERAGE_COMPILE_FLAGS "-fprofile-arcs -ftest-coverage")
      set(COVERAGE_LINK_FLAGS "-lgcov -fprofile-arcs -ftest-coverage")
    elseif(COMPILER_CHOICE STREQUAL "CLANG")
        set(COVERAGE_COMPILE_FLAGS "--coverage")
        set(COVERAGE_LINK_FLAGS "--coverage")
    endif()
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(COMPILER_SPECIFIC_FLAGS "${COMPILER_SPECIFIC_FLAGS} -O3")
endif()

# Combining all flags
set(FINAL_COMPILE_FLAGS "${COMPILER_SPECIFIC_FLAGS} ${COVERAGE_COMPILE_FLAGS}")
set(FINAL_LINK_FLAGS "${COVERAGE_LINK_FLAGS}")

set(CMAKE_CXX_FLAGS_INIT "${FINAL_COMPILE_FLAGS}")
set(CMAKE_C_FLAGS_INIT "${FINAL_COMPILE_FLAGS}")

# CMake configurations for security-hardened C/C++ builds
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# add_compile_options(-Wall -Wextra -Werror)
# add_compile_options(-D_FORTIFY_SOURCE=2)
# add_compile_options(-Wformat -Wformat-security)
# add_compile_options(-fstack-protector-strong)
# add_compile_options(-fwrapv -fno-strict-overflow -fno-delete-null-pointer-checks)

# add_link_options(-z relro -z now)
# add_link_options(-z noexecstack)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pie")


# Set the compiler flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_INIT}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${FINAL_LINK_FLAGS}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_INIT}")


# add_compile_options(${CMAKE_CXX_FLAGS_INIT})
# add_link_options("${CMAKE_EXE_LINKER_FLAGS} ${FINAL_LINK_FLAGS}")
