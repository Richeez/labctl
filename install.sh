#!/bin/bash

# ###############################################################################
# # LABCTL Installer
# ###############################################################################

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
# echo "Run:"
# echo
# echo "labctl version"



set -e

echo "LABCTL installer"

echo "Installation is not implemented yet."