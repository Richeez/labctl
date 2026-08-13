#!/usr/bin/env bash

###############################################################################
# Permissions
###############################################################################

permissions_fix() {

    find "$INSTALL_DIR" \
        -type f \
        -name "*.sh" \
        -exec chmod +x {} +

    chmod +x "$INSTALL_DIR/bin/labctl"

}

set_permissions() {

    chmod +x "$INSTALL_DIR/bin/labctl"

    find \
        "$INSTALL_DIR/commands" \
        -type f \
        -exec chmod +x {} \;

}