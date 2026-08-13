#!/usr/bin/env bash

###############################################################################
# Permissions
###############################################################################

permission_install() {

    find "$INSTALL_DIR" \
        -type f \
        -name "*.sh" \
        -exec chmod +x {} \;

    chmod +x "$INSTALL_DIR/bin/labctl"

}

permission_verify() {

    [[ -x "$INSTALL_DIR/bin/labctl" ]]

}