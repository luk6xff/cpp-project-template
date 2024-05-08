################################################################################
# Dockerfile for creating a cpp build environment
################################################################################


################################################################################
################################################################################
## PROJECT BUILD STAGE
################################################################################
################################################################################
#FROM ubuntu:22.04 as project-build
FROM debian:bookworm-slim as project-build

# Set docker image info
LABEL maintainer="Lukasz Uszko <lukasz.uszko@gmail.com>"
LABEL description="luk6xff's cpp project template"

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Create a default user and group
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG ARCH
ENV HOME /home/${USERNAME}

# Create a non-root user to use
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd -s /bin/bash -c ${USERNAME} -d ${HOME} --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    # Add sudo support
    && apt-get update \
    && apt-get install --no-install-recommends -qy sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # Cleanup
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

################################################################################
# Install luk6xff mandatory packages
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
    libgtest-dev \
    libgmock-dev \
    # Libraries
    gnupg \
    unzip \
    #gcc-multilib \
    build-essential \
    software-properties-common \
    # Python
    python3 \
    python3-pip \
    python3-venv \
    # Networking
    curl \
    # Code analysis
    cppcheck \
    iwyu \
    clang-tidy \
    clang-format \
    # Debugging/tracing
    gdb \
    gdbserver \
    valgrind \
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
    # Other tools
    lsb-release \
    jq \
    gawk \
    # Cleanup
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install GEF
RUN bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

# Setup python virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install pythom packages
RUN pip install --no-cache-dir cpplint

# Install Infer
RUN VERSION=1.1.0; \
curl -sSL "https://github.com/facebook/infer/releases/download/v$VERSION/infer-linux64-v$VERSION.tar.xz" \
| sudo tar -C /opt -xJ && \
sudo ln -s "/opt/infer-linux64-v$VERSION/bin/infer" /usr/local/bin/infer

# Install CodeChecker
ENV CODE_CHECKER_PATH=/opt/CodeChecker
ENV BUILD_LOGGER_64_BIT_ONLY=YES
# Set environment variables to include CodeChecker in the PATH
ENV PATH="${CODE_CHECKER_PATH}/build/CodeChecker/bin:${PATH}"
ENV CC_REPO_DIR="${CODE_CHECKER_PATH}"
# Expose the default port used by CodeChecker server
EXPOSE 8999

RUN if [ "$ARCH" = "-amd64" ]; then \
        curl -sL https://deb.nodesource.com/setup_16.x | bash - \
        && apt-get install -y nodejs \
        && git clone --depth 1 https://github.com/Ericsson/CodeChecker.git ${CODE_CHECKER_PATH} \
        && cd ${CODE_CHECKER_PATH} \
        && make package \
        && chmod +x ${CODE_CHECKER_PATH}/build/CodeChecker/bin/report-converter \
    ; fi



################################################################################
# Install additional packages required for your project
################################################################################
RUN apt-get update \
    && apt-get install --no-install-recommends -qy \
    libxrandr-dev \
    libxcursor-dev \
    libudev-dev \
    libfreetype-dev \
    libopenal-dev \
    libflac-dev \
    libvorbis-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    # Cleanup
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

################################################################################
# Setup
################################################################################
USER ${USERNAME}
WORKDIR $HOME



################################################################################
################################################################################
## PROJECT RUNTIME STAGE
################################################################################
################################################################################
#FROM project-build as project-runtime
FROM debian:bookworm-slim as project-runtime
RUN apt-get update \
    && apt-get install --no-install-recommends -qy \
    libxrandr2 \
    libxcursor1 \
    libudev1 \
    libfreetype6 \
    libopenal1 \
    libflac12 \
    libvorbisfile3 \
    libgl1 \
    libegl1 \
    gdbserver \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
COPY ../app/build/bin /app
#CMD ["/app/my_project"]
CMD ["gdbserver", ":2345", "/app/my_project"]

