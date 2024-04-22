#!/usr/bin/env bash
#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    ${SCRIPT_NAME}
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
#%    -a, --app               Run application build command for Application
#%    -acov,--app-coverity    Run application build command for Application with coverity
#%    -A, --app-noclean       Run application build command for Application, but without cleaning previous objects
#%    -Acov,--app-coverity-noclean    Run application build command for Application with coverity, but without cleaning previous objects
#%    -b, --build                Run full build (qnx and Application apps) command, creates image_prod for flashing
#%    -B, --build-noclean        Run full build (qnx and Application apps) command, but without cleaning previous objects
#%    -c, --clean                Run full clean command
#%    -i, --image                Create image_prod folder for flashing
#%    -u,--unit-tests             [component1_name [component2_name ...]]    Build and run unit tests for Application with coverage (or for specific sw component(s) without coverage)
#%    -U,--unit-tests-noclean     [component1_name [component2_name ...]]    Build and run unit tests for Application with coverage (or for specific sw component(s) without coverage), but without cleaning previous objects
#%    -it,--integration-tests            Build and run integration tests for Application
#%    -IT,--integration-tests-noclean    Build and run integration tests for Application, but without cleaning previous objects
#%    -qt,--qualification-tests          Build and run qualification tests for Application
#%    -QT,--qualification-tests-noclean  Build and run qualification tests for Application, but without cleaning previous objects
#%
#% ARGS
#%    None
#%
#% EXAMPLES
#%    cd /home/luk6xff/Projects/${PROJECT_NAME} && ./${SCRIPT_NAME} -b
#%
#%
#================================================================
#- IMPLEMENTATION
#-    version         ${SCRIPT_NAME} 1.0
#-    authors         Lukasz Uszko
#-    copyright       Copyright 2022 luktec, All Rights Reserved.
#-                    luktec Confidential
#-
#================================================================
#  HISTORY
#     2022-02-03 : Initial version
#
#================================================================
# END_OF_HEADER
#================================================================


set -o errexit   # Exit when error occurs
set -o pipefail  # Catch all pipes errors
set -o nounset   # Treat undeclared vars as errors

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__curr_dir="${PWD}"
__user=$(whoami)

SCRIPT_HEADSIZE=$(head -200 "${0}" |grep -n "^# END_OF_HEADER" | cut -f1 -d:)
SCRIPT_NAME="$(basename "${0}")"

usage() { head -"${SCRIPT_HEADSIZE:-99}" "${0}" | grep -e "^#[%+]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
usagefull() { head -"${SCRIPT_HEADSIZE:-99}" "${0}" | grep -e "^#[%+-]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
scriptinfo() { head -"${SCRIPT_HEADSIZE:-99}" "${0}" | grep -e "^#-" | sed -e "s/^#-//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g"; }
minimalmodebuildwarning() { echo "You are building Minimal Mode. Don't forget rebuild AIS also!"; sleep 2; }

#================================================================
# SCRIPT VARIABLES
#================================================================

PROJECT_NAME="my_project"
DOCKER_IMG="${PROJECT_NAME}"
DOCKER_IMG_TO_RUN="${DOCKER_IMG}"
DOCKER_IMAGE_FULL_NAME="jfrog.luktec.com/docker_images/${PROJECT_NAME}"

# Project host root directory
PATH_PROJECT_ROOT=${__curr_dir}

# Docker container home directory path
HOME_DIR="/home/${__user}"
DOCKER_PROJECT_ROOT="${HOME_DIR}"
[[ -n "${JENKINS_URL+x}" ]] && DOCKER_PROJECT_ROOT="${WORKSPACE}"

# QNX paths
PATH_QNX_DIR="QNX"
PATH_QNX_LICENSE=".qnx"
PATH_APPLICATION="MyApp"
PATH_DOCKER="ci"
PATH_QNX_HLOS_DEV="${DOCKER_PROJECT_ROOT}/${PATH_QNX_DIR}/hlos_dev_qnx"
PATH_QNX_SDP710="${HOME_DIR}/qnx710" # this path exists inside of the docker image
PATH_QNX_USER="${DOCKER_PROJECT_ROOT}/${PATH_QNX_DIR}/luktec"

# Commands
ENTRY_CMD="/bin/bash"
BUILD_CMD=${ENTRY_CMD}
ATTACH_TO='-i -a stdin -a stdout -a stderr'

# QNX build commands
BUILD_QNX_SET_ENV_CMD="cd ${PATH_QNX_HLOS_DEV}/apps/qnx_ap && source setenv_hyp710.sh --external ${PATH_QNX_SDP710} --app ${DOCKER_PROJECT_ROOT}/${PATH_APPLICATION} && source ${PATH_QNX_SDP710}/qnxsdp-env.sh"

cmake_make_command() {
	TOOLCHAINS=("Toolchain_qnx-aarch64le.cmake" "Toolchain_x86_64.cmake")
	TOOLCHAIN="${TOOLCHAINS[0]}"
	PROJECT=""
	EASY_ON="OFF"
	MINIMAL_MODE="OFF"
	FACTORY_MODE="OFF"
	KPI_MARKERS="OFF"
	COVERITY="OFF"
	PATH_PARTNER=0
	TESTS_OPTION=""

	MAKE_TARGET="install"
	MAKE_COVERAGE=0

	CTEST_RUN=0
	TEST_MODULES=""

	while [[ $# -gt 0 ]] && [[ ."$1" = .-* ]] ;
	do
		opt="$1";
		shift;
		case "$opt" in
			"-a"|"--app")
				PROJECT="Application";;
			"-v"|"--coverity")
				COVERITY="ON";;
			"-u"|"--unit-tests")
				TESTS_OPTION="-DPROJECT_UNIT_TESTS=ON"; MAKE_TARGET="tests"; MAKE_COVERAGE=1; TOOLCHAIN="${TOOLCHAINS[1]}";;
			"--run-tests")
				CTEST_RUN=1; MAKE_COVERAGE=0;
				if [ $# -gt 1 ]; then
					args=$(printf '%s|' "${@}"); args=${args%|};
					TEST_MODULES='"'"${args}"'"';
				else
					TEST_MODULES="${1}"
				fi;;
			"-it"|"--integration-tests")
				TESTS_OPTION="-DPROJECT_INTEGRATION_TESTS=ON";;
			"-qt"|"--qualification-tests")
				TESTS_OPTION="-DPROJECT_QUALIFICATION_TESTS=ON";;
			"--kpi")
				KPI_MARKERS="ON"

		esac
	done

	if [[ -z "${PROJECT}" ]]; then
		echo "Choose project" 1>&2
		exit 1
	fi

	FLAGS="-DCMAKE_BUILD_TYPE=Release -DPROJECT_TARGET=${PROJECT}-DTBFactoryMode=${FACTORY_MODE} -DCOVERITY_BUILD=${COVERITY} -DKPI_MARKERS=${KPI_MARKERS} ${TESTS_OPTION} -DCMAKE_TOOLCHAIN_FILE=../cmake/${TOOLCHAIN}"
	MAKE_CMD="make -j4 && make ${MAKE_TARGET}"
	if [[ $CTEST_RUN -ne 0 ]]; then
		MAKE_CMD="make -j4 && ctest -j4 --verbose -R ${TEST_MODULES}"
	fi
	if [[ $MAKE_COVERAGE -ne 0 ]]; then
		MAKE_CMD=" ${MAKE_CMD} && make code_coverage"
	fi
	echo "cmake ${FLAGS} .. && ${MAKE_CMD}"
}

goto_build_directory() {
	DIR_NAME="$1"

	SET_APP_ROOT_DIR="cd ${DOCKER_PROJECT_ROOT}/${PATH_APPLICATION}"

	CMD="${SET_APP_ROOT_DIR} && mkdir -p ${DIR_NAME} && cd ${DIR_NAME}"
	if [[ $# -gt 1 ]] && [[ $2 == "--no-clean" ]]; then
		:
	else
		CMD="${CMD} && rm -rf *"
	fi

	echo "$CMD"
}

build_qnx() {
	MINIMAL_MODE=0
	CLEAN=1
	CLEAN_ONLY=0

	QNX_DIR="${PATH_QNX_HLOS_DEV}/apps/qnx_ap"

	CMD=""
	while [[ $# -gt 0 ]] && [[ ."$1" = .-* ]] ;
	do
		opt="$1";
		shift;
		case "$opt" in
			"-m"|"--minimal-mode")
				MINIMAL_MODE=1;;
			"--no-clean")
				CLEAN=0;;
			"--clean-only")
				CLEAN_ONLY=1;;
		esac
	done

	if [[ $MINIMAL_MODE -eq 1 ]]; then
		BUILD_CMD="cd ${QNX_DIR} && make MINIMAL_MODE_BUILD=1"
	else
		BUILD_CMD="cd ${QNX_DIR} && make"
	fi
	CLEAN_CMD="cd ${QNX_DIR} && make clean && cd ${PATH_QNX_USER} && rm -rf image_prod && ./project_cleaner.sh"

	if [[ $CLEAN_ONLY -eq 1 ]]; then
		CMD="${CLEAN_CMD}"
	elif [[ $CLEAN -eq 1 ]]; then
		CMD="${CLEAN_CMD} && ${BUILD_CMD}"
	else
		CMD="${BUILD_CMD}"
	fi
	[[ -n "${JENKINS_URL+x}" ]] && CMD="${WORKSPACE}/CI/waitForQNXLicense.sh && ${CMD}"

	echo "$CMD"
}

build_command(){
	QNX=0
	QNX_CLEAN=0
	QNX_CREATE_IMAGE=0
	NO_CLEAN=""
	CMAKE_MAKE_OPTIONS=""
	QNX_BUILD_OPTIONS=""
	PROJECT_TAG=""
	TESTS=0
	TEST_LAUNCH=0
	TEST_PATH=""

	while [[ $# -gt 0 ]] && [[ ."$1" = .-* ]] ;
	do
		opt="$1";
		shift;
		case "$opt" in
			"-a"|"--app")
				TEST_PATH="Application"; PROJECT_TAG="tb"; CMAKE_MAKE_OPTIONS="${CMAKE_MAKE_OPTIONS} ${opt}";;
			"-u"|"--unit-tests"|"-i"|"--integration-tests"|"-q"|"--qualification-tests")
				TESTS=1; CMAKE_MAKE_OPTIONS="${CMAKE_MAKE_OPTIONS} ${opt}"
				if [ $# -ge 1 ]; then
					TEST_LAUNCH=1; CMAKE_MAKE_OPTIONS="${CMAKE_MAKE_OPTIONS} --run-tests";
				fi;;
			"--no-clean")
				NO_CLEAN="--no-clean";;
			"--chi")
				CHI=1;;
			"--build-qnx")
				QNX=1;;
			"--clean-qnx")
				QNX_CLEAN=1;;
			"--create-image")
				QNX_CREATE_IMAGE=1;;
			*)
				CMAKE_MAKE_OPTIONS="${CMAKE_MAKE_OPTIONS} ${opt}";;
		esac
	done

	if [[ -z "${PROJECT_TAG}" ]] && [[ $QNX_CLEAN -eq 0 ]] && [[ $QNX_CREATE_IMAGE -eq 0 ]]; then
		echo -e "Choose project"
		exit 1
	fi

	if [[ ${TESTS} -eq 1 ]]; then
		BUILD_DIR_SUFFIX="test"
	else
		BUILD_DIR_SUFFIX="app"
	fi

	BUILD_DIR="build_${PROJECT_TAG}_${BUILD_DIR_SUFFIX}"

	CMD=""

	BUILD_QNX_CREATE_IMAGE_CMD="cd ${PATH_QNX_HLOS_DEV}/apps/qnx_ap && make images && cd ${PATH_QNX_HLOS_DEV}/common/build && python build.py --flavor=8295_lv && cd ${PATH_QNX_USER} && ./create_image_prod.sh"

	if [[ $QNX -eq 1 ]]; then
		CMD="$(build_qnx ${QNX_BUILD_OPTIONS} ${NO_CLEAN}) && $(goto_build_directory ${BUILD_DIR} ${NO_CLEAN}) && $(cmake_make_command ${CMAKE_MAKE_OPTIONS}) && ${BUILD_QNX_CREATE_IMAGE_CMD}"
	elif [[ $QNX_CLEAN -eq 1 ]]; then
		CMD="$(build_qnx --clean-only)"
	elif [[ $QNX_CREATE_IMAGE -eq 1 ]]; then
		CMD="${BUILD_QNX_CREATE_IMAGE_CMD}"
	elif [[ $TEST_LAUNCH -eq 1 ]]; then
		CMD="$(goto_build_directory ${BUILD_DIR}/${TEST_PATH} ${NO_CLEAN}) && $(cmake_make_command ${CMAKE_MAKE_OPTIONS} $@)"
	else
		CMD="$(goto_build_directory ${BUILD_DIR} ${NO_CLEAN}) && $(cmake_make_command ${CMAKE_MAKE_OPTIONS})"
	fi
	echo "time(${CMD})"
}

################################################################################
###  NOTE!!! Modify this only when a new image has been created!
################################################################################
DOCKER_TAG="0.1"
DOCKER_TAG_TO_PULL="0.1" # this is used by CI to build UTs and will need to be changed when CI updates for now


# Check if PATH_PROJECT_ROOT path exists
[ -d "${PATH_PROJECT_ROOT}" ] &&  echo "Directory ${PATH_PROJECT_ROOT} found." || {
	echo "Directory ${PATH_PROJECT_ROOT} not found. Please pass a valid project directory path!"
	usage
	exit 1
}
DOCKER_DIR="${PATH_PROJECT_ROOT}/${PATH_DOCKER}"


while [[ $# -gt 0 ]] && [[ ."$1" = .-* ]] ;
do
	opt="$1";
	shift;
	case "$opt" in
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
			BUILD_OPTIONS="--app";;
		"-A"|"--app-noclean" )
			BUILD_OPTIONS="--app --no-clean";;
		"-acov"|"--app-coverity" )
			BUILD_OPTIONS="--app --coverity";;
		"-Acov"|"--app-coverity-noclean" )
			BUILD_OPTIONS="--app --coverity --no-clean";;
		"-b"|"--build" )
			BUILD_OPTIONS="--build-qnx --app";;
		"-B"|"--build-noclean" )
			BUILD_OPTIONS="--build-qnx --app --no-clean";;
		"-c"|"--clean" )
			BUILD_OPTIONS="--clean-qnx";;
		"-i"|"--image" )
			BUILD_OPTIONS="--create-image";;
		"-u"|"--unit-tests" )
			BUILD_OPTIONS="--app -u $@";;
		"-U"|"--unit-tests-noclean" )
			BUILD_OPTIONS="--app --no-clean -u $@";;
		"-it"|"--integration-tests" )
			BUILD_OPTIONS="--app -it";;
		"-IT"|"--integration-tests-noclean" )
			BUILD_OPTIONS="--app -it --no-clean";;
		"-qt"|"--qualification-tests" )
			BUILD_OPTIONS="--app -qt";;
		"-QT"|"--qualification-tests-noclean" )
			BUILD_OPTIONS="--app -qt --no-clean";;
		"--kpi")
			BUILD_OPTIONS="${BUILD_OPTIONS-''} --kpi";;
		*) echo >&2 "Invalid option: $opt"; exit 1;;
	esac
done

if [[ -n ${BUILD_OPTIONS+x} ]]; then
	BUILD_CMD="$(build_command ${BUILD_OPTIONS})"
fi

if [ "${BUILD_CMD}" != "${ENTRY_CMD}" ]; then
	ATTACH_TO='-a stdout -a stderr';
fi

MISC_FILE=/home/${__user}/.local/bin/misc.sh
handle_term()
{
	if [[ -f ${MISC_FILE} ]]; then
		${MISC_FILE}
	fi

	exit 2
}

pull_image(){
    echo 'Provide Id and Password to login to jfrog.luktec.com'
    read -p "Id: " id
    read -sp "Password: " passvar
    echo
    echo "Logging to docker registry at jfrog.luktec.com"
    echo ${passvar} | docker login -u ${id} --password-stdin jfrog.luktec.com
    echo "Pulling ${PROJECT_NAME} image..."
    out=$( docker pull ${DOCKER_IMAGE_FULL_NAME}:${DOCKER_TAG_TO_PULL} || echo "Failed")
	if [[ "$out" =~ .*"Status: Downloaded newer image for".* ]] ; then
		return 0
	else
    	return 1
	fi
}

_main() {

	echo >&2 "Chosen ${PROJECT_NAME}"
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
		# sudo groupadd docker
		sudo usermod -aG docker ${__user}
		newgrp docker
		echo "RUNNING HELLO-WORLD DEMO DOCKER APP..."
		sudo docker run hello-world
		echo >&2 ">>> Docker installed succesfully on your machine! <<<"
		exit 1
	fi

	# Search for docker image
	image_query=$( docker images -q "${DOCKER_IMG}":"${DOCKER_TAG}" )

	if [[ -n "${image_query}" ]]; then
		echo "Docker image: ["${DOCKER_IMAGE_FULL_NAME}":"${DOCKER_TAG_TO_PULL}"] exists"
	else
		echo -e "Image not found, pulling image from jfrog.luktec.com"
		set +e # pull image might fail, if so, fallback to building image locally
		#pull_image
		#res=$?
		res=1
		if [[ $res == 0 ]]; then
			docker image tag ${DOCKER_IMAGE_FULL_NAME}:${DOCKER_TAG_TO_PULL} ${DOCKER_IMG}:${DOCKER_TAG}
		else
			echo "Pull  failed, attempting to build image from Dockerfile"
			#read -p "Provide path to QNX sdp (relative to CI directory, should be placed in CI directory)" sdp_path
			docker build	-t ${DOCKER_IMG}:${DOCKER_TAG}            \
						--build-arg USERNAME=${__user}              \
						--build-arg USER_UID=$(id -u)              \
						--build-arg USER_GID=$(id -g)             \
						-f ${DOCKER_DIR}/Dockerfile \
						${DOCKER_DIR}
			echo ">>> Docker image: ${DOCKER_IMG}:${DOCKER_TAG} has been built successfully! <<<"
		fi
		set -e
	fi

	echo >&2 "Running ${DOCKER_IMG_TO_RUN} docker container..."

	if [[ -f ${MISC_FILE} ]]; then
		${MISC_FILE}
	fi

	trap 'handle_term' EXIT INT TERM
	docker run -ti --rm ${ATTACH_TO} -u $(id -u):$(id -g) \
		--name ${PROJECT_NAME} \
		--privileged \
		--security-opt apparmor=unconfined \
		--group-add=dialout \
		--net=host \
		--log-opt max-size=10m \
		--log-opt max-file=2 \
		-e APPS_REVISION=$(git describe --always --long --abbrev=16) \
		-e APPS_IMAGE_VERSION=${DOCKER_IMG}:${DOCKER_TAG} \
		-e DISPLAY=$DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v ~/.ssh:/home/luk6xff/.ssh \
		-v ${PATH_PROJECT_ROOT}:${DOCKER_PROJECT_ROOT} \
		-v /etc/hosts:/etc/hosts \
		${DOCKER_IMG_TO_RUN}:${DOCKER_TAG} ${ENTRY_CMD} -c "${BUILD_CMD}"
		#${DOCKER_IMG_TO_RUN}:${DOCKER_TAG} ${ENTRY_CMD} -c "${BUILD_QNX_SET_ENV_CMD} && ${BUILD_CMD}"
	trap - EXIT INT TERM

	if [[ -f ${MISC_FILE} ]]; then
		${MISC_FILE}
	fi

	exit 0
}

_main_ci() {
	${ENTRY_CMD} -c "${BUILD_QNX_SET_ENV_CMD} && ${BUILD_CMD}"
}

if [[ -z "${JENKINS_URL+x}" ]]; then
	_main
else
	_main_ci
fi
