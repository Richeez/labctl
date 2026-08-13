#!/usr/bin/env bash

###############################################################################
# Uninstall
###############################################################################

system_uninstall() {

    ui_start "Removing launcher"

    file_remove "$BIN_LINK"

    ui_finish

    ################################################

    ui_start "Removing application"

    file_remove "$INSTALL_DIR"

    ui_finish

    ################################################

    ui_start "Removing cache"

    directory_remove "$CACHE_DIR"

    ui_finish

    ################################################

    ui_start "Removing runtime state"

    directory_remove "$STATE_DIR"

    ui_finish

}