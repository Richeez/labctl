#!/usr/bin/env bash

###############################################################################
# Installer Common Utilities
###############################################################################

install_assert_root() {

    if (( EUID != 0 )); then
        log_error "Root privileges required."
        return "$EXIT_PERMISSION_DENIED"
    fi

}

install_assert_installed() {

    [[ -d "$INSTALL_DIR" ]] || {
        log_error "LABCTL is not installed."
        return "$EXIT_FAILURE"
    }

}

install_assert_not_installed() {

    [[ ! -d "$INSTALL_DIR" ]] || {
        log_error "LABCTL is already installed."
        return "$EXIT_FAILURE"
    }

}

install_confirm() {

    local MESSAGE="$1"

    printf "%s [y/N]: " "$MESSAGE"

    read -r ANSWER

    [[ "$ANSWER" =~ ^[Yy]$ ]]

}

install_timestamp() {

    date +"%Y%m%d-%H%M%S"

}

install_temp_dir() {

    printf "%s/install-%s\n" \
        "$STATE_DIR" \
        "$(install_timestamp)"

}