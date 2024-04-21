rm -rf build
TOOLCHAIN="Toolchain_x86_64.cmake"
cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug  -DCMAKE_TOOLCHAIN_FILE="cmake/${TOOLCHAIN}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
#cmake -DCMAKE_BUILD_TYPE=Debug  -DCMAKE_TOOLCHAIN_FILE="cmake/${TOOLCHAIN}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DPROJECT_TARGET="my_project" .. && make
#cmake --build build
