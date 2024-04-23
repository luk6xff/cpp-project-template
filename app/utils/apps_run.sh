#!/bin/bash

SCRIPT_DIR_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CMD_RUN_PATH=${SCRIPT_DIR_PATH}/../

echo ">>> Start running apps..."
cd ${CMD_RUN_PATH}
./build/bin/my_project

echo "> Apps run command finished successfully!"
