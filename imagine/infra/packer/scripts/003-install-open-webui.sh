#!/bin/bash

# Script to install and set up Open WebUI
# Author: Your Name
# Date: YYYY-MM-DD

set -euo pipefail

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

create_directory() {
    local dir_path="$1"
    log "Creating directory $dir_path..."
    mkdir -p "$dir_path"
    log "Directory $dir_path created."
}

clone_repository() {
    local repo_url="$1"
    local dest_dir="$2"
    log "Cloning repository from $repo_url to $dest_dir..."
    git clone "$repo_url" "$dest_dir"
    log "Repository cloned successfully."
}

install_conda() {
    local conda_installer="Anaconda3-2024.06-1-Linux-x86_64.sh"
    log "Downloading Anaconda installer..."
    wget -q "https://repo.anaconda.com/archive/$conda_installer"
    log "Installing Anaconda..."
    bash "$conda_installer" -b -p "$HOME/anaconda3"
    rm "$conda_installer"
    export PATH="$HOME/anaconda3/bin:$PATH"
    log "Anaconda installed successfully."
}

setup_frontend() {
    # Source NVM to make it available in the current session
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

    log "Setting up frontend..."
    cd "$1"
    cp -RPp .env.example .env
    npm install
    # npm run dev & # TODO: perhaps this needs to run after the baking?
    log "Frontend setup completed."
}

setup_backend() {
    log "Setting up backend..."
    cd "$1/backend"
    log "Creating Conda environment..."
    conda create --name open-webui-env python=3.11 -y
    log "Activating Conda environment..."
    source activate open-webui-env
    log "Installing backend dependencies..."
    pip install -r requirements.txt -U
    # bash dev.sh & # TODO: perhaps this needs to run after the baking?
    log "Backend setup completed."
}

# Main Script Execution
log "Starting Open WebUI setup..."

# Check if the script is run as root
check_root

# Define installation directory
INSTALL_DIR="/opt/open-webui"

# Create the installation directory
create_directory "$INSTALL_DIR"

# Clone the repository
REPO_URL="https://github.com/open-webui/open-webui.git"
clone_repository "$REPO_URL" "$INSTALL_DIR"

# Install Conda
install_conda

# Setup frontend
setup_frontend "$INSTALL_DIR"

# Setup backend
setup_backend "$INSTALL_DIR"

log "Open WebUI setup completed successfully."