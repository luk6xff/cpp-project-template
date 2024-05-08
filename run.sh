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
#%    -r, --run                  Run the application with detached docker mode
#%    -ri, --run-interactive     Run the application with interactive docker mode
#%    -s, --session              Run docker interactive session
#%    -pb, --prod-build          Run full production build, creates a production image
#%    -pr, --prod-run         	 Run production build run command
#%    -sc, --scan-image          Run scan docker image command
#%    -f, --format               Run formatter on the source code
#%
#% CONTAINER_ARGS
#%    None
#%
#% EXAMPLES
#%    cd /home/luk6xff/Projects/${PROJECT_NAME} && ./${SCRIPT_NAME} -a -amd64
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

function usage() { head -"${SCRIPT_HEADSIZE:-99}" "${0}" | grep -e "^#[%+]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
function usagefull() { head -"${SCRIPT_HEADSIZE:-99}" "${0}" | grep -e "^#[%+-]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
function scriptinfo() { head -"${SCRIPT_HEADSIZE:-99}" "${0}" | grep -e "^#-" | sed -e "s/^#-//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g"; }

#================================================================
# SCRIPT VARIABLES
#================================================================
# Dockert image and project name
PROJECT_NAME="my_project"
DOCKER_IMG="${PROJECT_NAME}"
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

# Set default architecture and toolchain file
ARCH="-amd64"
TOOLCHAIN_FILE="cmake/Toolchain/Linux_x86_64.cmake"

# Commands utils
ENTRY_CMD="/bin/bash"
RUN_CMD=${ENTRY_CMD}
CONTAINER_ARGS='-i --rm -a stdin -a stdout -a stderr'

echo ">>> Running script: ${SCRIPT_NAME} <<<"

# Project specific build commands
BUILD_SET_ENV_CMD="cd ${APPS_DIR}"

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

#########################################################################################
### HELPER FUNCTIONS
#########################################################################################

# Check architecture
function verify_arch() {
	architecture="$1";
	case "$architecture" in
		"-armv6" )
			DOCKER_IMG_ARCH="linux/arm/v6"
			TOOLCHAIN_FILE="cmake/Toolchain/Linux_armv6.cmake";;
		"-armv7" )
			DOCKER_IMG_ARCH="linux/arm/v7"
			TOOLCHAIN_FILE="cmake/Toolchain/Linux_armv7.cmake";;
		"-arm64" )
			DOCKER_IMG_ARCH="linux/arm64"
			TOOLCHAIN_FILE="cmake/Toolchain/Linux_arm64.cmake";;
		"-amd64" )
			DOCKER_IMG_ARCH="linux/amd64"
			TOOLCHAIN_FILE="cmake/Toolchain/Linux_x86_64.cmake";;
		*)
			# The wrong platform argument.
			echo 'Invalid platform ARCH applied, expected: "armv6", "armv7", "arm64" or "amd64"'
			exit 1;;
	esac

	DOCKER_IMG="${PROJECT_NAME}${ARCH}"
	echo ">>> Selected docker image architecture: ${DOCKER_IMG_ARCH} "
	echo ">>> Selected docker image: ${DOCKER_IMG} "
}

function check_and_install_docker() {
	# Check if docker is installed
	if [ -x "$(command -v docker)" ]; then
		echo "Docker is installed on your OS"
	else
		echo "Docker is NOT installed. Install Docker to proceed with compilation."
		echo "Script will automatically install all necessary packages for docker engine."
		echo "When all packages are installed it tries to run hello_world docker application which will mean that docker is installed succesfully."
		# Instructions based on: https://docs.docker.com/install/linux/docker-ce/ubuntu/
		sudo apt-get update
		sudo apt install docker.io
		sudo apt install docker-buildx
		sudo usermod -aG docker ${USER}
		newgrp docker <<-END
		echo "This is running as group $(id)"
		END
		#echo "Running hello-world test docker-app..."
		#docker run hello-world
		echo ">>> Docker installed succesfully on your machine!<<<"
	fi
}

function scan_image() {
	cd ${DOCKER_DIR}
	docker run --rm -i hadolint/hadolint < Dockerfile
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${DOCKER_IMG}:${DOCKER_TAG}
}

function format_code() {
	cd ${PROJECT_ROOT_PATH}
}

function pull_image(){
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

function build_image_dev() {
	# Install docker
	check_and_install_docker
	# Set architecture
	verify_arch $ARCH
	# Search for docker image
	image_query=$( docker images -q "${DOCKER_IMG}":"${DOCKER_TAG}" )
	if [[ -n "${image_query}" ]]; then
		echo "Docker image: ["${DOCKER_IMG}":"${DOCKER_TAG}"] exists"
	else
		echo -e "Docker image: ["${DOCKER_IMG}":"${DOCKER_TAG}"] not found, start pulling image from: ${DOCKER_IMAGE_FULL_NAME}:${DOCKER_TAG} ..."
		set +e # pull image might fail, if so, fallback to building image locally
		pull_image
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
								--target project-build				\
								--platform ${DOCKER_IMG_ARCH}		\
								-f ${DOCKER_DIR}/${DOCKERFILE_NAME} \
								--output="type=docker,push=false,dest=${DOCKER_DIR}/${DOCKER_IMG}.tar" \
								${PROJECT_ROOT_PATH}
			res=$?
			if [[ $res == 0 ]]; then
				echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} has been built successfully! <<<"
				echo "Loading docker image as: ${DOCKER_IMG}:${DOCKER_TAG} ..."
				docker load --input ${DOCKER_DIR}/${DOCKER_IMG}.tar
				# echo "Saving docker image as: ${DOCKER_IMG}:${DOCKER_TAG}.tar.gz ..."
				# docker save ${DOCKER_IMG}:${DOCKER_TAG} | gzip > ${DOCKER_DIR}/${DOCKER_IMG}-${DOCKER_TAG}.tar.gz
				echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} has been saved successfully! <<<"
			else
				echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} build failed! <<<"
				exit 1
			fi
		fi
		set -e
	fi
}

function build_all_dev() {
	echo "Building development image..."
	build_image_dev
	echo "Building the apps..."
	run_container_dev
	exit 0
}

function run_container_dev() {
	# Run docker container
	echo "Running ${DOCKER_IMG} docker container..."

	# Remove dangling containers first if any
	docker container prune -f

	docker run ${CONTAINER_ARGS} \
		--name "${DOCKER_IMG}" \
		--privileged \
		--cap-add=SYS_PTRACE \
		--security-opt apparmor=unconfined \
		--security-opt seccomp=unconfined \
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


function build_image_prod() {
	# Check architecture
	verify_arch $ARCH
	# Build apps first
	build_all_dev
	# Run production build image
	echo "Building the production image..."
	DOCKER_IMG="${DOCKER_IMG}-production"
	echo "Start building: [${DOCKER_IMG}:${DOCKER_TAG}] ..."

	# Create the builder (if not already created)
	docker buildx build	--builder=my_builder				\
						--tag ${DOCKER_IMG}:${DOCKER_TAG}	\
						--build-arg USERNAME=${USER}		\
						--build-arg USER_UID=$(id -u)		\
						--build-arg USER_GID=$(id -g)		\
						--build-arg ARCH=${ARCH}			\
						--target project-runtime			\
						--platform ${DOCKER_IMG_ARCH}		\
						-f ${DOCKER_DIR}/${DOCKERFILE_NAME} \
						--output="type=docker,push=false,dest=${DOCKER_DIR}/${DOCKER_IMG}.tar" \
						${PROJECT_ROOT_PATH}
	res=$?
	if [[ $res == 0 ]]; then
		echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} has been built successfully! <<<"
		echo "Loading docker image as: ${DOCKER_IMG}:${DOCKER_TAG} ..."
		docker load --input ${DOCKER_DIR}/${DOCKER_IMG}.tar
		# echo "Saving docker image as: ${DOCKER_IMG}:${DOCKER_TAG}.tar.gz ..."
		# docker save ${DOCKER_IMG}:${DOCKER_TAG} | gzip > ${DOCKER_DIR}/${DOCKER_IMG}-${DOCKER_TAG}.tar.gz
		echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} has been saved successfully! <<<"
	else
		echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} build failed! <<<"
		exit 1
	fi
}

function run_container_prod() {
	DOCKER_IMG="${DOCKER_IMG}-production"
	CONTAINER_ARGS='-i -a stdin -a stdout -a stderr'
	# Run docker container
	echo "Running ${DOCKER_IMG} docker container..."

	# Remove dangling containers first if any
	docker kill ${DOCKER_IMG} || true
	docker container prune -f
	docker run ${CONTAINER_ARGS} \
		--name "${DOCKER_IMG}" \
		--privileged \
		--cap-add=SYS_PTRACE \
		--security-opt apparmor=unconfined \
		--security-opt seccomp=unconfined \
		--group-add=dialout \
		--net=host \
		--log-opt max-size=10m \
		--log-opt max-file=2 \
		--restart unless-stopped \
		-e DISPLAY=$DISPLAY \
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/:/tmp \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		${DOCKER_IMG}:${DOCKER_TAG}
}


#########################################################################################
### DOCKER CONTAINER COMMANDS (Sets RUN_CMD variable passed to the container)
#########################################################################################
# Set up the environment and navigate to the apps directory
function setup_environment() {
    echo "Setting up environment..."
    cd "${APPS_DIR}" || exit 1
}

# Function to perform a configurable CMake build
function cmake_build() {
	local build_type=$1
	local profiler_enabled=$2
	local clean_build=${3:-"false"} # Optional clean build directory
	local toolchain_file=${4:-"cmake/Toolchain/Linux_x86_64.cmake"} # Default toolchain if not specified
	local unit_tests=${5:-"OFF"} # Default to no unit tests unless specified
	local perform_code_analysis=${6:-"OFF"} # Default to no code analysis unless specified

	echo "Starting CMake build process..."
	echo "Build type: ${build_type}, Profiler Enabled: ${profiler_enabled}, Toolchain: ${toolchain_file}, Unit Tests: ${unit_tests}, Code Analysis: ${perform_code_analysis}"

	if [[ "${clean_build}" == "true" ]]; then
		echo "Cleaning build directory before starting build..."
		rm -rf ${APPS_DIR}/build
	fi

	# Configure the project with CMake
	RUN_CMD="cmake -S . -B build \
		-DCMAKE_BUILD_TYPE=${build_type} \
		-DPROFILER_ENABLED=${profiler_enabled} \
		-DCMAKE_TOOLCHAIN_FILE=${toolchain_file} \
		-DUNIT_TESTS=${unit_tests} \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=${perform_code_analysis} \
		&& cmake --build build --config ${build_type}"

	# Build and run unit tests if requested
	if [ "${unit_tests}" = "ON" ]; then
		RUN_CMD="${RUN_CMD} && cmake --build build -t unit_tests"
		echo "Running unit tests..."
	fi

	# Perform code analysis if requested
	if [ "${perform_code_analysis}" = "ON" ]; then
		echo "Performing code analysis..."
		RUN_CMD="${RUN_CMD} && cmake --build build -t docs && cmake --build build -t codechecker"
	fi

	# Install the project
	RUN_CMD="${RUN_CMD} && cmake --install build"
}


# Function to run the application
function run_app() {
	local command_type=$1 # 'run', 'gdb'
	local gdb_port=${2:-"2345"} # Optional GDB port for debugging

	if [[ "${clean_build}" == "true" ]]; then
		echo "Cleaning build directory..."
		rm -rf build
	fi

	case "${command_type}" in
		run)
			echo "Running application..."
			RUN_CMD="./build/bin/${PROJECT_NAME}";;
		gdb)
			echo "Running application with gdbserver on port ${gdb_port}..."
			RUN_CMD="gdbserver :${gdb_port} "./build/bin/${PROJECT_NAME}"";;
		*)
			echo "Invalid command type: ${command_type}"
			return 1
			;;
	esac
}



#########################################################################################
### MAIN SCRIPT
#########################################################################################
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

# Set architecture
verify_arch ${ARCH}
echo OPTIONS: $OPT, ARCHITECTURE: $ARCH

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
		cmake_build "Release" "OFF" "true" "${TOOLCHAIN_FILE}";
		CMD=build_all_dev;;
	"-A"|"--app-noclean" )
		cmake_build "Release" "OFF" "false" "${TOOLCHAIN_FILE}";
		CMD=build_all_dev;;
	"-ad"|"--app-debug" )
		cmake_build "Debug" "ON" "true" "${TOOLCHAIN_FILE}";
		CMD=build_all_dev;;
	"-Ad"|"--app-debug-noclean" )
		cmake_build "Debug" "ON" "false" "${TOOLCHAIN_FILE}";
		CMD=build_all_dev;;
	"-u"|"--unit-tests" )
		cmake_build "Debug" "ON" "true" "${TOOLCHAIN_FILE}" "ON" "OFF";
		CMD=build_all_dev;;
	"-U"|"--unit-tests-noclean" )
		cmake_build "Debug" "ON" "false" "${TOOLCHAIN_FILE}" "ON" "OFF";
		CMD=build_all_dev;;
	"-ca"|"--code-analysis" )
		cmake_build "Debug" "ON" "true" "${TOOLCHAIN_FILE}" "OFF" "ON";
		CMD=build_all_dev;;
	"-i"|"--image" )
		CMD="build_image_dev";;
	"-r"|"--run" )
		run_app "run"
		CONTAINER_ARGS='-d --restart unless-stopped'
		CMD=run_container_dev;;
	"-ri"|"--run-interactive" )
		run_app "run"
		CMD=run_container_dev;;
	"-rig"|"--run-interactive-gdb" )
		run_app "gdb"
		CMD=run_container_dev;;
	"-s"|"--session" )
		CONTAINER_ARGS='-it --rm -a stdin -a stdout -a stderr'
		CMD=run_container_dev;;
	"-pb"|"--build" )
		cmake_build "Debug" "ON" "false" "${TOOLCHAIN_FILE}";
		CMD=build_image_prod;;
	"-pr"|"--run-prod" )
		CMD=run_container_prod;;
	"-sc"|"--scan-image" )
		CMD=scan_image;;
	"-f"|"--format" )
		CMD=format_code;;
	*)
		# The wrong command argument.
		echo "Invalid option: $OPT";
		exit 1;;
esac

# Run the command
${CMD}
