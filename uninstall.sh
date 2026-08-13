#!/usr/bin/env bash

set -Eeuo pipefail


source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib/core" && pwd)/home.sh"
source lib/core/bootstrap.sh

logo_print

system_uninstall || {

    system_rollback

    exit 1

}

ui_start "Verifying uninstallation"

workflow_begin UNINSTALL_WORKFLOW

ui_finish

echo
log_success "LABCTL uninstalled successfully."

# echo
# banner

# # ###############################################################################
# # # LABCTL Installer
# # ###############################################################################

# set -euo pipefail

# INSTALL_DIR="/opt/labctl"
# BIN_LINK="/usr/local/bin/labctl"

# echo "=========================================="
# echo "Installing LABCTL..."
# echo "=========================================="

# # Root check
# if [[ "$EUID" -ne 0 ]]; then
#     echo "Please run with sudo."
#     exit 1
# fi

# # Create required directories
# mkdir -p "$INSTALL_DIR"
# mkdir -p /etc/labctl
# mkdir -p /var/log/labctl
# mkdir -p /var/lib/labctl
# mkdir -p /var/cache/labctl

# # Copy project
# cp -R ./* "$INSTALL_DIR"

# # Default configuration
# if [[ ! -f /etc/labctl/config.json ]]; then
#     cp config/default.json /etc/labctl/config.json
# fi

# # Permissions
# find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \;
# chmod +x "$INSTALL_DIR/bin/labctl"

# # Symbolic link
# ln -sf "$INSTALL_DIR/bin/labctl" "$BIN_LINK"

# echo
# echo "Installation Complete."
# echo
# banner
# echo 
# echo "Run:"
# echo
# echo "labctl version"



# # set -e

# # echo "LABCTL installer"

# # echo "Installation is not implemented yet."