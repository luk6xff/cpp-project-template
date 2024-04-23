#!/bin/bash

SCRIPT_DIR_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUT_DIR_PATH=${SCRIPT_DIR_PATH}/../build

echo ">>> Cleaning ${OUT_DIR_PATH} directory..."
rm -rf ${OUT_DIR_PATH}

echo "> Clean command finished successfully!"
