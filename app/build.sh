rm -rf build
# TOOLCHAIN="Toolchain_x86_64.cmake"
# cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug  -DCMAKE_TOOLCHAIN_FILE="cmake/${TOOLCHAIN}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
# cmake --build build




cmake -S . -B build
cmake --build build --config Release && ./build/my_project
./build/bin/my_project
