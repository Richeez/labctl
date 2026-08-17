#!/usr/bin/env bash

###############################################################################
# Verify Installation
###############################################################################

system_verify() {

    directory_exists "$CONFIG_DIR" || return 1

    directory_exists "$CACHE_DIR" || return 1

    [[ -x "$INSTALL_DIR/bin/labctl" ]] || return 1

    launcher_verify || return 1

    [[ -f "$CONFIG_FILE" ]] || return 1

    return 0

}
