################################################################################
# Dockerfile for creating a cpp build environment
################################################################################

#FROM ubuntu:22.04
FROM debian:bookworm-slim

# Set docker image info
LABEL maintainer="Lukasz Uszko <lukasz.uszko@gmail.com>"
LABEL Description="luk6xff's cpp project template"

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Create a default user and group
ARG USERNAME
ARG USER_UID
ARG USER_GID
ENV HOME /home/${USERNAME}

# Create a non-root user to use
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd -s /bin/bash -c ${USERNAME} -d ${HOME} --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    # Add sudo support
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # Cleanup
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

################################################################################
# Install LUK6xFF mandatory packages
################################################################################
RUN apt-get update && apt-get install --no-install-recommends -qy \
    # Build tools
    make \
    autoconf \
    automake \
    ninja-build \
    libtool \
    m4 \
    cmake \
    ccache\
    # GNU Toolchain
    gcc \
    g++ \
    # LLVM Toolchain
    clang \
    clang-tools \
    clangd \
    lld \
    lldb \
    # C/C++ libraries
    libboost-all-dev \
    libgtest-dev \
    libgmock-dev \
    libgoogle-glog-dev \
    libgoogle-perftools-dev \
    libbenchmark-dev \
    # Libraries
    gnupg \
    unzip \
    #gcc-multilib \
    build-essential \
    software-properties-common \
    # Python
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    python3-setuptools \
    # Networking
    curl \
    wget \
    socat \
    # Code analysis
    cppcheck \
    iwyu \
    clang-tidy \
    clang-format \
    # Debugging/tracing
    gdb \
    valgrind \
    ltrace \
    strace \
    # Code coverage
    lcov \
    gcovr \
    # Documentation
    doxygen \
    graphviz \
    doxygen-latex \
    doxygen-doxyparse\
    # Version control
    git \
    git-flow \
    # Other tools
    lsb-release \
    jq \
    gawk \
    ###
    # clean up
    && rm -rf /var/lib/apt/lists/*

# Setup python virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install cpplint
RUN pip install cpplint

# Install Infer
RUN VERSION=1.1.0; \
curl -sSL "https://github.com/facebook/infer/releases/download/v$VERSION/infer-linux64-v$VERSION.tar.xz" \
| sudo tar -C /opt -xJ && \
sudo ln -s "/opt/infer-linux64-v$VERSION/bin/infer" /usr/local/bin/infer

# Install CodeChecker
ENV CODE_CHECKER_PATH=/opt/CodeChecker
ENV BUILD_LOGGER_64_BIT_ONLY=YES
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN git clone https://github.com/Ericsson/CodeChecker.git --depth 1 ${CODE_CHECKER_PATH} && \
    cd ${CODE_CHECKER_PATH} && \
    make package
# Set environment variables to include CodeChecker in the PATH
ENV PATH="${CODE_CHECKER_PATH}/build/CodeChecker/bin:${PATH}"
ENV CC_REPO_DIR="${CODE_CHECKER_PATH}"
# Set the report-converter permissions
RUN chmod +x ${CODE_CHECKER_PATH}/build/CodeChecker/bin/report-converter
# Expose the default port used by CodeChecker server
EXPOSE 8999

################################################################################
# Install additional packages required for your project
################################################################################
RUN apt-get update \
    && apt install --no-install-recommends -qy \
    libxrandr-dev \
    libxcursor-dev \
    libudev-dev \
    libfreetype-dev \
    libopenal-dev \
    libflac-dev \
    libvorbis-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev

# clean up
RUN rm -rf /var/lib/apt/lists/*


################################################################################
# Setup
################################################################################
USER ${USERNAME}
WORKDIR $HOME
