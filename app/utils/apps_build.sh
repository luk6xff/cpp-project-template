#!/bin/bash

SCRIPT_DIR_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CMD_RUN_PATH=${SCRIPT_DIR_PATH}/../

echo ">>> Start building apps..."
cd ${CMD_RUN_PATH}
cmake -S . -B build
cmake --build build --config Debug #--config Release
# documentation
cmake --build build -t docs
# code checker
#cmake --build build -t codechecker
#cmake --install build

echo "> Apps build command finished successfully!"
