#!/usr/bin/env bash

###############################################################################
# Verify Installation
###############################################################################

system_verify() {

    dependency_exists nmcli || return 1

    directory_exists "$CONFIG_DIR" || return 1

    directory_exists "$CACHE_DIR" || return 1

    file_exists "$BIN_LINK" || return 1

    return 0

}