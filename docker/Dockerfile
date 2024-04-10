################################################################################
# Dockerfile for creating a cpp build environment
################################################################################

FROM ubuntu:22.04

# Set docker image info
LABEL maintainer="Lukasz Uszko <lukasz.uszko@gmail.com>"
LABEL Description="luk6xff's cpp project template"

# Create a default user and group
ARG USERNAME
ARG USER_UID
ARG USER_GID
ENV HOME /home/${USERNAME}

# Create a non-root user to use
RUN groupadd --gid ${USER_GID} ${USERNAME}
RUN useradd -s /bin/bash -c ${USERNAME} -d ${HOME} --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}
    # Add sudo support.
RUN apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
&&
# Clean up
apt-get autoremove -y \
&& apt-get clean -y \
&& rm -rf /var/lib/apt/lists/*

# RUN groupadd --gid $USER_GID $USERNAME \
#     && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
#     #
#     # Add sudo support.
#     && apt-get update \
#     && apt-get install -y sudo \
#     && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#     && chmod 0440 /etc/sudoers.d/$USERNAME
# &&
# # Clean up
# apt-get autoremove -y \
# && apt-get clean -y \
# && rm -rf /var/lib/apt/lists/*

# Set envs
ENV DEBIAN_FRONTEND noninteractive

COPY services /etc/services

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
    libstdc++-dev \
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
    gcc-multilib=4:7.4.0-1ubuntu2.3 \
    build-essential=12.4ubuntu1 \
    software-properties-common=0.96.24.32.14 \
    # Python
    python3 \
    python3-pip\
    # Networking
    curl \
    wget \
    socat \
    # Code analysis
    cppcheck \
    iwyu \
    clang-analyzer \
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
    ###
    # clean up
    && rm -rf /var/lib/apt/lists/*


################################################################################
# Install additional packages
################################################################################
RUN apt-get update -y && apt-get install --no-install-recommends -qy \
    # fastboot
    fastboot \
    # dtc
    device-tree-compiler \
    ###
    # clean up
    && rm -rf /var/lib/apt/lists/*

# repo tool
RUN wget -O /usr/local/bin/repo http://storage.googleapis.com/git-repo-downloads/repo \
    && chmod a+x /usr/local/bin/repo

# clean up
RUN rm -rf /var/lib/apt/lists/*


################################################################################
# Setup
################################################################################
USER ${user}
WORKDIR $HOME
