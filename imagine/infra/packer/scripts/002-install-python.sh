#!/bin/bash

# Script to install the latest version of Python 3 on Ubuntu 22.04
# Author: Your Name
# Date: YYYY-MM-DD

set -euo pipefail

# Variables
PYTHON_VERSION="3.12.0"
PYTHON_SRC_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"
PYTHON_SRC_TAR="Python-${PYTHON_VERSION}.tgz"
PYTHON_SRC_DIR="Python-${PYTHON_VERSION}"

# Functions
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log "This script must be run as root"
        exit 1
    fi
}

install_dependencies() {
    log "Updating package list..."
    sudo apt update

    log "Installing dependencies..."
    sudo apt install -y software-properties-common build-essential zlib1g-dev \
        libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget
}

add_deadsnakes_ppa() {
    log "Adding deadsnakes PPA..."
    sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt update
}

install_python_from_ppa() {
    log "Installing Python ${PYTHON_VERSION} from deadsnakes PPA..."
    sudo apt install -y "python${PYTHON_VERSION}"
}

download_python_source() {
    log "Downloading Python ${PYTHON_VERSION} source code..."
    wget "${PYTHON_SRC_URL}"
}

extract_and_compile_python() {
    log "Extracting Python source code..."
    tar -xvf "${PYTHON_SRC_TAR}"

    log "Configuring the build..."
    cd "${PYTHON_SRC_DIR}"
    ./configure --enable-optimizations

    log "Compiling and installing Python..."
    sudo make altinstall

    cd ..
}

cleanup() {
    log "Cleaning up..."
    rm -rf "${PYTHON_SRC_DIR}" "${PYTHON_SRC_TAR}"
}

verify_installation() {
    log "Verifying Python installation..."
    python3.12 --version
}

set_default_python() {
    log "Setting Python ${PYTHON_VERSION} as the default python3..."
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.12 1
    sudo update-alternatives --config python3
}

# Main Script Execution
check_root
install_dependencies
add_deadsnakes_ppa

# Attempt to install from PPA first
if install_python_from_ppa; then
    log "Python ${PYTHON_VERSION} installed successfully from PPA."
else
    log "Failed to install Python ${PYTHON_VERSION} from PPA. Falling back to source installation."
    download_python_source
    extract_and_compile_python
    cleanup
fi

verify_installation
set_default_python

log "Python ${PYTHON_VERSION} installation completed successfully."