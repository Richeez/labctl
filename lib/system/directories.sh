#!/usr/bin/env bash

###############################################################################
# Directory Management
###############################################################################

directory_create() {

    local DIR="$1"

    [[ -d "$DIR" ]] && return 0

    mkdir -p "$DIR"

}

###############################################################################

directory_remove() {

    local DIR="$1"

    [[ -d "$DIR" ]] || return 0

    rm -rf "$DIR"

}

###############################################################################

directory_exists() {

    [[ -d "$1" ]]

}

###############################################################################

directories_create() {

    local DIRECTORY


    for DIRECTORY in \
        "$CONFIG_DIR" \
        "$CACHE_DIR" \
        "$STATE_DIR" \
        "$LOG_DIR" \
        "$BACKUP_ROOT" \
        "$TRANSACTION_DIR"
    do

        if [[ ! -d "$DIRECTORY" ]]; then

            directory_create "$DIRECTORY" || {

                log_error "Failed to create directory: $DIRECTORY"

                return "$EXIT_FAILURE"

            }

            transaction_track_directory "$DIRECTORY"

        fi

    done


    return "$EXIT_SUCCESS"

}

###############################################################################

directories_remove() {

    directory_remove "$CACHE_DIR"

}