#!/usr/bin/env bash

###############################################################################
# LABCTL Filesystem
###############################################################################

filesystem_exists() {

    [[ -e "$1" ]]

}

filesystem_directory() {

    mkdir -p "$1"

}

filesystem_remove() {

    local TARGET="$1"

    [[ -n "$TARGET" ]] || return 1

    [[ "$TARGET" != "/" ]] || return 1
    [[ "$TARGET" != "/etc" ]] || return 1
    [[ "$TARGET" != "/usr" ]] || return 1
    [[ "$TARGET" != "/opt" ]] || return 1
    [[ "$TARGET" != "/var" ]] || return 1

    rm -rf "$TARGET"

}

filesystem_copy() {

    local SOURCE="$1"
    local DESTINATION="$2"

    rsync \
        -a \
        --exclude=".git" \
        --exclude=".github" \
        --exclude=".vscode" \
        --exclude="tests" \
        --exclude="docs" \
        --exclude="*.md" \
        --exclude="Makefile" \
        "$SOURCE/" \
        "$DESTINATION/"

}

filesystem_install_file() {

    local SOURCE="$1"
    local DESTINATION="$2"

    install \
        -Dm644 \
        "$SOURCE" \
        "$DESTINATION"

}

filesystem_move() {

    mv "$1" "$2"

}

filesystem_symlink() {

    local SOURCE="$1"
    local DESTINATION="$2"

    ln -sfn "$SOURCE" "$DESTINATION"

}

filesystem_permission() {

    chmod "$1" "$2"

}

filesystem_owner() {

    chown "$1" "$2"

}

filesystem_touch() {

    touch "$1"

}


###############################################################################
# Application Removal
###############################################################################

remove_application() {

    if [[ ! -d "$INSTALL_DIR" ]]; then
        log_info "Application is not installed."
        return 0
    fi

    log_info "Removing application files..."

    filesystem_remove "$INSTALL_DIR"

    if [[ -d "$INSTALL_DIR" ]]; then
        log_error "Failed to remove application directory."
        return "$EXIT_FAILURE"
    fi

    log_success "Application removed."

}


###############################################################################
# Log Cleanup
###############################################################################

logs_clear() {

    filesystem_directory "$LOG_DIR"

    if [[ ! -d "$LOG_DIR" ]]; then
        log_error "Unable to access log directory."
        return "$EXIT_FAILURE"
    fi

    find "$LOG_DIR" \
        -type f \
        -exec truncate -s 0 {} \;

    log_success "Logs cleared."

}