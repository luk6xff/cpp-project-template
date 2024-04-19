TOOLCHAIN="Toolchain_x86_64.cmake"
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug  -DCMAKE_TOOLCHAIN_FILE="cmake/${TOOLCHAIN}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
