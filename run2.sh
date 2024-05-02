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

set -o errexit   # Exit when error occurs
set -o pipefail  # Catch all pipes errors
set -o nounset   # Treat undeclared vars as errors

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
readonly PROJECT_ROOT="${SCRIPT_PATH}"
readonly APPS_DIR="${PROJECT_ROOT}/app"
readonly DOCKERFILE_PATH="${PROJECT_ROOT}/ci"

# Docker image details
readonly DOCKER_IMAGE_FULL_NAME="jfrog.luktec.com/docker_images/${PROJECT_NAME}"
#########################################################################################
###  NOTE!!! Modify DOCKER_TAG variable only when a new image version is gonna be crated
#########################################################################################
readonly DOCKER_TAG="0.1"


# Commands
readonly ENTRY_CMD="/bin/bash"
readonly RUN_CMD="${ENTRY_CMD}"
readonly ARGS='-i --rm -a stdin -a stdout -a stderr'

echo ">>> Running script: ${SCRIPT_NAME} <<<"

# Project specific build commands
BUILD_SET_ENV_CMD="cd ${APPS_DIR}"

APPS_BUILD_CMD="cmake -S . -B build && cmake --build build --config Debug && cmake --build build -t docs" # cmake --build build -t codechecker && cmake --install build"
APPS_RUN_CMD="./build/bin/${PROJECT_NAME}"
UT_BUILD_CMD="cmake -S . -B build -DUNIT_TESTS=ON -DCOMPILER_CHOICE=GCC -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=cmake/Toolchain/Linux_x86_64.cmake && cmake --build build && cmake --build build -t unit_tests"
CLEAN_CMD="rm -rf build"


# Functions
usage() {
    local headsize=$(head -200 "${0}" | grep -n "^# END_OF_HEADER" | cut -f1 -d:)
    head -"${headsize:-99}" "${0}" | grep -e "^#[%+]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g"
}

verify_dependencies() {
    if ! command -v docker &>/dev/null; then
        echo "Docker is not installed. Please install Docker to proceed."
        exit 1
    fi
    if ! command -v cmake &>/dev/null; then
        echo "CMake is not installed. Please install CMake to proceed."
        exit 1
    fi
}

build_docker_image() {
    verify_dependencies
    echo "Building Docker image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
    docker build -t "${DOCKER_IMAGE}:${DOCKER_TAG}" -f "${DOCKERFILE_PATH}/Dockerfile" "${PROJECT_ROOT}"
}

run_docker_container() {
    echo "Running Docker container: ${DOCKER_IMAGE}:${DOCKER_TAG}"
    #docker run --rm -it \
	# Remove dangling containers first if any
	docker container prune -f

	docker run ${ARGS} \
		--name "${DOCKER_IMG}" \
		--privileged \
		--security-opt apparmor=unconfined \
		--group-add=dialout \
		--net=host \
		--log-opt max-size=10m \
		--log-opt max-file=2 \
		-e APPS_REVISION=$(git describe --always --long --abbrev=16) \
		-e APPS_IMAGE_VERSION=${DOCKER_IMG}:${DOCKER_TAG} \
		-e DISPLAY=$DISPLAY \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/:/tmp \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v ~/.ssh:/home/${USER}/.ssh \
		--volume ${APPS_DIR}:${APPS_DIR} \
		${DOCKER_IMG}:${DOCKER_TAG} ${ENTRY_CMD} -c "${BUILD_SET_ENV_CMD} && ${RUN_CMD}"
}

clean_project() {
    echo "Cleaning build directories..."
    rm -rf "${APPS_DIR}/build"
}

build_project() {
    echo "Building project..."
    cmake -S "${APPS_DIR}" -B "${APPS_DIR}/build"
    cmake --build "${APPS_DIR}/build"
}


parse_options() {
    while getopts ":hvabcf" opt; do
        case ${opt} in
            h)
                usage
                exit 0
                ;;
            v)
                echo "${SCRIPT_NAME} version 1.0"
                exit 0
                ;;
            a)
                build_docker_image
                ;;
            b)
                build_project
                ;;
            c)
                clean_project
                ;;
            f)
                format_code  # This function should be defined to handle code formatting
                ;;
            *)
                echo "Invalid option: ${OPTARG}" >&2
                usage
                exit 1
                ;;
        esac
    done
    shift $((OPTIND -1))
}

main() {
    parse_options "$@"
}

main "$@"



_verify_arch() {
	architecture="$1";
	case "$architecture" in
		"-armv6" )
			DOCKER_IMG_ARCH="linux/arm/v6";;
		"-armv7" )
			DOCKER_IMG_ARCH="linux/arm/v7";;
		"-aarch64" )
			DOCKER_IMG_ARCH="linux/arm64";;
		"-amd64" )
			DOCKER_IMG_ARCH="linux/amd64";;
		*)
			# The wrong platform argument.
			echo 'Invalid platform ARCH applied, expected: "armv6", "armv7", "aarch64" or "amd64"' >&2
			exit 1;;
	esac

	DOCKER_IMG="${PROJECT_NAME}${ARCH}"
	echo ">>> Chosen docker image architecture: ${DOCKER_IMG_ARCH} "
	echo ">>> Chosen docker image: ${DOCKER_IMG} "
}


_check_and_install_docker() {
	# Check if docker is installed
	if [ -x "$(command -v docker)" ]; then
		echo >&2 "Docker is installed on your OS"
	else
		echo >&2 "Docker is NOT installed. Install Docker to proceed with compilation."
		echo >&2 "Script will automatically install all necessary packages for docker engine."
		echo >&2 "When all packages are installed it tries to run hello_world docker application which will mean that docker is installed succesfully."
		# Instructions based on: https://docs.docker.com/install/linux/docker-ce/ubuntu/
		sudo apt-get update
		sudo apt install docker.io
		sudo apt install docker-buildx
		sudo usermod -aG docker ${USER}
		newgrp docker <<-END
		echo >&2 "This is running as group $(id)"
		END
		#echo "Running hello-world test docker-app..."
		#docker run hello-world
		echo >&2 ">>> Docker installed succesfully on your machine!<<<"
	fi
}

_check_and_install_docker_multiarch() {
	# Search for docker multiarch/qemu-user-static image
	DOCKER_MULTIARCH_IMG="multiarch/qemu-user-static:latest"
	image_query=$( docker images -q ${DOCKER_MULTIARCH_IMG} )
	if [[ -n "${image_query}" ]]; then
		echo "Docker image ["${DOCKER_MULTIARCH_IMG}"] exists, start running"
	else
		echo "Docker image ["${DOCKER_MULTIARCH_IMG}"] doesn't exist, start building/downloading"
	fi
	echo ">>> Running ${DOCKER_MULTIARCH_IMG} image... <<<"
	docker run --rm --privileged ${DOCKER_MULTIARCH_IMG} --reset -p yes
}

_format_code() {
	cd ${PROJECT_ROOT_PATH}
}

_pull_image(){
	echo 'Provide Id and Password to login to jfrog.luktec.com'
	read -p "Id: " id
	read -sp "Password: " passvar
	echo
	echo "Logging to docker registry at jfrog.luktec.com"
	echo ${passvar} | docker login -u ${id} --password-stdin jfrog.luktec.com
	echo "Pulling ${PROJECT_NAME} image..."
	out=$( docker pull ${DOCKER_IMAGE_FULL_NAME}:${DOCKER_TAG} || echo "Failed")
	if [[ "$out" =~ .*"Status: Downloaded newer image for".* ]] ; then
		return 0
	else
		return 1
	fi
}

_build_image() {
	# Install docker
	_check_and_install_docker
	# Install multiarch
	_check_and_install_docker_multiarch
	# Set architecture
	_verify_arch $ARCH
	# Search for docker image
	image_query=$( docker images -q "${DOCKER_IMG}":"${DOCKER_TAG}" )
	if [[ -n "${image_query}" ]]; then
		echo "Docker image: ["${DOCKER_IMG}":"${DOCKER_TAG}"] exists"
	else
		echo -e "Docker image: ["${DOCKER_IMG}":"${DOCKER_TAG}"] not found, start pulling image from: ${DOCKER_IMAGE_FULL_NAME}:${DOCKER_TAG} ..."
		set +e # pull image might fail, if so, fallback to building image locally
		_pull_image
		res=$?
		if [[ $res == 0 ]]; then
			docker image tag ${DOCKER_IMAGE_FULL_NAME}:${DOCKER_TAG} ${DOCKER_IMG}:${DOCKER_TAG}
		else
			echo "Pull failed, attempting to build image from Dockerfile"
			echo "Start building: [${DOCKER_IMG}:${DOCKER_TAG}] ..."

			docker buildx build	--tag ${DOCKER_IMG}:${DOCKER_TAG}	\
								--build-arg USERNAME=${USER}		\
								--build-arg USER_UID=$(id -u)		\
								--build-arg USER_GID=$(id -g)		\
								--build-arg ARCH=${ARCH}			\
								--platform ${DOCKER_IMG_ARCH}		\
								-f ${DOCKER_DIR}/Dockerfile			\
								${PROJECT_ROOT_PATH}
			res=$?
			if [[ $res == 0 ]]; then
				echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} has been built successfully! <<<"
				echo "Saving docker image as: ${DOCKER_IMG}:${DOCKER_TAG}.tar.gz ..."
				#docker save ${DOCKER_IMG}:${DOCKER_TAG} | gzip > ${DOCKER_DIR}/${DOCKER_IMG}:${DOCKER_TAG}.tar.gz LU_TODO
				echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} has been saved successfully! <<<"
			else
				echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} build failed! <<<"
				exit 1
			fi
		fi
		set -e
	fi
}

_build_all() {
	echo "Building image..."
	_build_image
	echo "Building the apps..."
	_run
	exit 0
}

_build_apps() {
	# Check architecture
	_check_arch $ARCH
	# Run apps build
	echo "Building the app..."
	cd ${PROJECT_ROOT_PATH}
}

_run() {
	# Check architecture
	_verify_arch ${ARCH}
	# Run docker container
	echo >&2 "Running ${DOCKER_IMG} docker container..."

	# Remove dangling containers first if any
	docker container prune -f

	docker run ${ARGS} \
		--name "${DOCKER_IMG}" \
		--privileged \
		--security-opt apparmor=unconfined \
		--group-add=dialout \
		--net=host \
		--log-opt max-size=10m \
		--log-opt max-file=2 \
		-e APPS_REVISION=$(git describe --always --long --abbrev=16) \
		-e APPS_IMAGE_VERSION=${DOCKER_IMG}:${DOCKER_TAG} \
		-e DISPLAY=$DISPLAY \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/:/tmp \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v ~/.ssh:/home/${USER}/.ssh \
		--volume ${APPS_DIR}:${APPS_DIR} \
		${DOCKER_IMG}:${DOCKER_TAG} ${ENTRY_CMD} -c "${BUILD_SET_ENV_CMD} && ${RUN_CMD}"
	exit 0
}

${CMD}
