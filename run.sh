#!/bin/bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#%    ${SCRIPT_NAME}
#%
#% DESCRIPTION
#%    This is script to automatically build a complete environment
#%    with all tools needed for compilation of ${PROJECT_NAME} project
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
#%    -sc, --scan-image          Run scan docker image command
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
#     2022-12-07 : Initial version
#
#================================================================
# END_OF_HEADER
#================================================================

set -o errexit   # Exit when error occurs
set -o pipefail  # Catch all pipes errors
set -o nounset   # Treat undeclared vars as errors

DIR_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE_PATH="${DIR_PATH}/$(basename "${BASH_SOURCE[0]}")"
CURR_DIR="${DIR_PATH}"
USER=$(whoami)

SCRIPT_HEADSIZE=$(head -200 "${0}" |grep -n "^# END_OF_HEADER" | cut -f1 -d:)
SCRIPT_NAME="$(basename "${0}")"

usage() { head -"${SCRIPT_HEADSIZE:-99}" "${0}" | grep -e "^#[%+]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
usagefull() { head -"${SCRIPT_HEADSIZE:-99}" "${0}" | grep -e "^#[%+-]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
scriptinfo() { head -"${SCRIPT_HEADSIZE:-99}" "${0}" | grep -e "^#-" | sed -e "s/^#-//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g"; }

#================================================================
# SCRIPT VARIABLES
#================================================================
# Dockert image and project name
PROJECT_NAME="my_project"
DOCKER_IMG="${PROJECT_NAME}"
DOCKER_IMG_TO_RUN="${DOCKER_IMG}"
DOCKER_IMAGE_FULL_NAME="jfrog.luktec.com/docker_images/${PROJECT_NAME}"
# Project host root directory
PROJECT_ROOT_PATH=${CURR_DIR}
# Apps directory path in docker container
APPS_DIR=${PROJECT_ROOT_PATH}/app
# Docker container home directory paths
HOME_DIR="/home/${USER}"
# Docker file dir path
DOCKERFILE_PATH="ci"
DOCKERFILE_NAME="Dockerfile"
# Set default architecture
ARCH="-amd64"

# Commands utils
ENTRY_CMD="/bin/bash"
RUN_CMD=${ENTRY_CMD}
ARGS='-i --rm -a stdin -a stdout -a stderr'

echo ">>> Running script: ${SCRIPT_NAME} <<<"

# Project specific build commands
BUILD_SET_ENV_CMD="cd ${APPS_DIR}"

APPS_RELEASE_BUILD_CMD="cmake -S . -B build -DPROFILER_ENABLED=OFF && cmake --build build --config Release && cmake --build build -t docs && cmake --build build -t codechecker && cmake --install build"
APPS_DEBUG_BUILD_CMD="cmake -S . -B build -DPROFILER_ENABLED=ON && cmake --build build --config Debug && cmake --build build -t docs && cmake --build build -t codechecker && cmake --install build"

APPS_RUN_CMD="./build/bin/${PROJECT_NAME}"
UT_BUILD_CMD="cmake -S . -B build -DUNIT_TESTS=ON -DCOMPILER_CHOICE=GCC -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=cmake/Toolchain/Linux_x86_64.cmake && cmake --build build && cmake --build build -t unit_tests"
CLEAN_CMD="rm -rf build"

#########################################################################################
###  NOTE!!! Modify DOCKER_TAG variable only when a new image version is gonna be crated
#########################################################################################
DOCKER_TAG="0.1"

# Check if PROJECT_ROOT_PATH path exists
[ -d "${PROJECT_ROOT_PATH}" ] &&  echo "Directory ${PROJECT_ROOT_PATH} found." || {
	echo "Directory ${PROJECT_ROOT_PATH} not found. Please pass a valid app directory path!"
	usage
	exit 1
}

DOCKER_DIR="${PROJECT_ROOT_PATH}/${DOCKERFILE_PATH}"

# Parse opts
[[ $# -eq 0 ]] && echo "No arguments supplied" && usage && exit 1;
OPT="$1";

if [[ $# -eq 1 ]];
then
	echo "No arch selected, defaulting to ${ARCH}";
else
	if [[ -z "$2" ]];
	then
		echo "No arch selected, defaulting to ${ARCH}";
	else
		ARCH="$2";
	fi
fi

case "$OPT" in
	"-h"|"-?"|"--help"|"--usage" )
		usage;
		exit 0;;
	"-v"|"-version"|"--v"|"--version" )
		scriptinfo;
		exit 0;;
	"--debug" )
		set -o xtrace;;
	"--silent" )
		exec > /dev/null 2>&1
		PRINT_RESULTS=false;;
	"-a"|"--app" )
		RUN_CMD="time (${CLEAN_CMD} && ${APPS_RELEASE_BUILD_CMD}; exit 0)"
		CMD=_build_all;;
	"-A"|"--app-noclean" )
		RUN_CMD="time (${APPS_RELEASE_BUILD_CMD})"
		CMD=_build_all;;
	"-ad"|"--app-debug" )
		RUN_CMD="time (${CLEAN_CMD} && ${APPS_DEBUG_BUILD_CMD}; exit 0)"
		CMD=_build_all;;
	"-Ad"|"--app-debug-noclean" )
		RUN_CMD="time (${APPS_DEBUG_BUILD_CMD})"
		CMD=_build_all;;
	"-u"|"--unit-tests" )
		RUN_CMD="time (${CLEAN_CMD} && ${UT_BUILD_CMD})"
		CMD=_build_all;;
	"-U"|"--unit-tests-noclean" )
		RUN_CMD="time (${UT_BUILD_CMD})"
		CMD=_build_all;;
	"-i"|"--image" )
		RUN_CMD="time (${CLEAN_CMD}; exit 0)"
		CMD="_build_image";;
	"-d"|"--docker" )
		CMD=_check_and_install_docker;;
	"-b"|"--build" )
		RUN_CMD="time (${APPS_RELEASE_BUILD_CMD}; exit 0)"
		CMD=_build_all;;
	"-c"|"--clean" )
		RUN_CMD="time (${CLEAN_CMD})"
		CMD=_run;;
	"-r"|"--run" )
		RUN_CMD="time (${APPS_RUN_CMD})"
		ARGS='-d --restart unless-stopped'
		CMD=_run;;
	"-ri"|"--run-interactive" )
		RUN_CMD="time (${APPS_RUN_CMD})"
		CMD=_run;;
	"-s"|"--session" )
		RUN_CMD="${ENTRY_CMD}"
		ARGS='-it --rm -a stdin -a stdout -a stderr'
		CMD=_run;;
	"-sc"|"--scan-image" )
		CMD=_scan_image;;
	"-f"|"--format" )
		CMD=_format_code;;
	*)
		# The wrong command argument.
		echo >&2 "Invalid option: $OPT";
		exit 1;;
esac



_verify_arch() {
	architecture="$1";
	case "$architecture" in
		"-armv6" )
			DOCKER_IMG_ARCH="linux/arm/v6";;
		"-armv7" )
			DOCKER_IMG_ARCH="linux/arm/v7";;
		"-arm64" )
			DOCKER_IMG_ARCH="linux/arm64";;
		"-amd64" )
			DOCKER_IMG_ARCH="linux/amd64";;
		*)
			# The wrong platform argument.
			echo 'Invalid platform ARCH applied, expected: "armv6", "armv7", "arm64" or "amd64"' >&2
			exit 1;;
	esac

	DOCKER_IMG="${PROJECT_NAME}${ARCH}"
	echo ">>> Selected docker image architecture: ${DOCKER_IMG_ARCH} "
	echo ">>> Selected docker image: ${DOCKER_IMG} "
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

_scan_image() {
	_verify_arch $ARCH
	cd ${DOCKER_DIR}
	docker run --rm -i hadolint/hadolint < Dockerfile
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${DOCKER_IMG}:${DOCKER_TAG}
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

			# Create the builder (if not already created)
			docker buildx create --name my_builder --driver=docker-container --use
			# Start the builder instance
			docker buildx inspect --bootstrap
			docker buildx build	--builder=my_builder				\
								--tag ${DOCKER_IMG}:${DOCKER_TAG}	\
								--build-arg USERNAME=${USER}		\
								--build-arg USER_UID=$(id -u)		\
								--build-arg USER_GID=$(id -g)		\
								--build-arg ARCH=${ARCH}			\
								--platform ${DOCKER_IMG_ARCH}		\
								-f ${DOCKER_DIR}/${DOCKERFILE_NAME} \
								--output="type=docker,push=false,dest=${DOCKER_DIR}/${DOCKER_IMG}.tar" \
								${PROJECT_ROOT_PATH}
			res=$?
			if [[ $res == 0 ]]; then
				echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} has been built successfully! <<<"
				echo "Loading docker image as: ${DOCKER_IMG}:${DOCKER_TAG} ..."
				docker load --input ${DOCKER_DIR}/${DOCKER_IMG}.tar
				echo "Saving docker image as: ${DOCKER_IMG}:${DOCKER_TAG}.tar.gz ..."
				docker save ${DOCKER_IMG}:${DOCKER_TAG} | gzip > ${DOCKER_DIR}/${DOCKER_IMG}-${DOCKER_TAG}.tar.gz
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
