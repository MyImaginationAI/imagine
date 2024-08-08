#!/bin/bash

# First-run setup script for a brand new Ubuntu 24.04 server on AWS
# Author: Valter Silva
# Date: 2024-08-08

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

update_and_upgrade() {
    log "Updating package list and upgrading installed packages..."
    sudo apt update && sudo apt upgrade -y
    log "Removing unnecessary packages..."
    sudo apt autoremove -y
}

install_common_utilities() {
    log "Installing common utilities..."
    sudo apt install -y curl wget git vim htop ufw
}

setup_firewall() {
    log "Setting up UFW firewall..."
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw enable
}

install_fail2ban() {
    log "Installing and configuring Fail2Ban..."
    sudo apt install -y fail2ban
    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban
}

configure_time_sync() {
    log "Configuring time synchronization..."
    sudo apt install -y chrony
    sudo systemctl enable chrony
    sudo systemctl start chrony
}

create_user() {
    local username="$1"
    log "Creating user $username..."
    sudo adduser --gecos "" "$username"
    sudo usermod -aG sudo "$username"
    log "User $username created and added to sudo group."
}

# Main Script Execution
check_root
update_and_upgrade
install_common_utilities
# setup_firewall
# install_fail2ban
configure_time_sync

create_user "imagine"

log "Initial server setup completed successfully."