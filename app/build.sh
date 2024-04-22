rm -rf build
# TOOLCHAIN="Toolchain_x86_64.cmake"
# cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug  -DCMAKE_TOOLCHAIN_FILE="cmake/${TOOLCHAIN}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
# cmake --build build




cmake -S . -B build
cmake --build build --config Release && ./build/my_project
# documentation
cmake --build build -t docs
# cpp check
cmake --build build -t cppcheck
# clang-tidy
cmake --build build -t clang_tidy


# Run the project
./build/bin/my_project
