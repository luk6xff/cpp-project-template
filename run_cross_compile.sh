#!/bin/bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#%    ${SCRIPT_NAME}
#%
#% DESCRIPTION
#%    Automates the environment setup and manages Docker containers
#%    for the ${PROJECT_NAME} project, handling various tasks such
#%    as building images, running containers, and performing tests.
#%
#% OPTIONS
#%    -h, --help, -?, --usage    Print this help
#%    -v, --version              Print version
#%    --debug                    Print expression before executing
#%    --silent                   Echo off
#%    -a, --app               	 Run build command for the app
#%    -A, --app-noclean
#%    -u, --unit-tests             [component1_name [component2_name ...]]    Build and run unit tests for Application with coverage (or for specific sw component(s) without coverage)
#%    -U, --unit-tests-noclean
#%    -it, --integration-tests            Build and run integration tests for Application
#%    -IT, --integration-tests-noclean
#%    -qt, --qualification-tests          Build and run qualification tests for Application
#%    -QT, --qualification-tests-noclean
#%    -i, --image                Build docker image
#%    -d, --docker               Checks and install docker on the machine if needed
#%    -b, --build                Run full build (docker image and the app) command, creates ${PROJECT_NAME}_img ready for use
#%    -B, --build-noclean
#%    -c, --clean                Run full clean command
#%    -r, --run                  Run the application with detached docker mode
#%    -ri, --run-interactive     Run the application with interactive docker mode
#%    -s, --session              Run docker interactive session
#%    -f, --format               Run formatter on the source code
#%
#% ARGS
#%    None
#%
#% EXAMPLES
#%    cd /home/luk6xff/Projects/${PROJECT_NAME} && ./${SCRIPT_NAME} -b x64
#%
#%
#================================================================
#- IMPLEMENTATION
#-    version         ${SCRIPT_NAME} 1.0
#-    authors         Lukasz Uszko
#-    copyright       Copyright 2022 luk6xff, All Rights Reserved.
#-
#================================================================
#  HISTORY
#     2022/12/07 : luk6xff : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

# set -o errexit   # Exit when error occurs
# set -o pipefail  # Catch all pipes errors
# set -o nounset   # Treat undeclared vars as errors

readonly DIR_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly FILE_PATH="${DIR_PATH}/$(basename "${BASH_SOURCE[0]}")"
readonly SCRIPT_NAME="$(basename "${0}")"
readonly SCRIPT_VERSION="1.1"
readonly USER=$(whoami)

#================================================================
# SCRIPT VARIABLES
#================================================================
readonly PROJECT_NAME="my_project"
readonly DOCKER_IMAGE="jfrog.luktec.com/docker_images/${PROJECT_NAME}"
readonly PROJECT_ROOT="${DIR_PATH}"
readonly APPS_DIR="${PROJECT_ROOT}/app"
readonly DOCKERFILE_PATH="${PROJECT_ROOT}/ci"

# Docker image details
readonly DOCKER_IMAGE_FULL_NAME="jfrog.luktec.com/docker_images/${PROJECT_NAME}"
#########################################################################################
###  NOTE!!! Modify DOCKER_TAG variable only when a new image version is gonna be crated
#########################################################################################
readonly DOCKER_TAG="0.1"


docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t luk6xff/${PROJECT_NAME}:latest Dockerfile_cross_compile
