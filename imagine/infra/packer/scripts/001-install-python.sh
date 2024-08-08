#!/bin/bash

# Script to install the latest version of Python 3 on Ubuntu 22.04
# Author: Your Name
# Date: YYYY-MM-DD

set -euo pipefail

# Variables
PYTHON_VERSION="3.12"

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
    sudo apt install -y software-properties-common
}

add_deadsnakes_ppa() {
    log "Adding deadsnakes PPA..."
    sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt update
}

install_python_from_ppa() {
    log "Installing Python ${PYTHON_VERSION} from deadsnakes PPA..."
    sudo apt install -y "python${PYTHON_VERSION}" "python${PYTHON_VERSION}-venv" "python${PYTHON_VERSION}-distutils"
}

install_pip_and_virtualenv() {
    log "Installing pip and virtualenv for Python ${PYTHON_VERSION}..."
    curl -sS https://bootstrap.pypa.io/get-pip.py | sudo "python${PYTHON_VERSION}"
    sudo "python${PYTHON_VERSION}" -m pip install --upgrade pip
    sudo "python${PYTHON_VERSION}" -m pip install virtualenv
}

verify_installation() {
    log "Verifying Python installation..."
    python${PYTHON_VERSION} --version
    pip${PYTHON_VERSION} --version
    virtualenv --version
}

set_default_python() {
    log "Setting Python ${PYTHON_VERSION} as the default python3..."
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1
    sudo update-alternatives --config python3
}

# Main Script Execution
check_root
install_dependencies
add_deadsnakes_ppa
install_python_from_ppa
install_pip_and_virtualenv
verify_installation
set_default_python

log "Python ${PYTHON_VERSION} installation completed successfully."