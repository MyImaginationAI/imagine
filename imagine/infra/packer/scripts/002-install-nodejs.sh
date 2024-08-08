#!/bin/bash

# Script to install the latest version of NVM and Node.js
# Author: Your Name
# Date: YYYY-MM-DD

set -euo pipefail

# Functions
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

install_nvm() {
    log "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

    # Source NVM to make it available in the current session
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

    log "NVM installed successfully."
}

install_latest_node() {
    log "Installing the latest version of Node.js..."
    nvm install node
    nvm use node
    nvm alias default node
    log "Latest version of Node.js installed and set as default."
}

# Main Script Execution
install_nvm

# Reload .bashrc to apply NVM changes
log "Reloading .bashrc to apply NVM changes..."
source ~/.bashrc

# Explicitly set the terminal type to avoid tput errors
export TERM=xterm

install_latest_node

log "NVM and Node.js setup completed successfully."