#!/usr/bin/env bash

###############################################################################
# Rollback
###############################################################################

rollback_restore() {

    local SOURCE="$1"
    local DEST="$2"

    [[ -d "$SOURCE" ]] || return 0

    rm -rf "$DEST"

    cp -a "$SOURCE" "$DEST"

}

rollback_run() {

    local BACKUP

    BACKUP="$(backup_latest)"

    [[ -n "$BACKUP" ]] || {
        log_error "No backup available."
        return 1
    }

    rollback_restore \
        "$BACKUP/install" \
        "$INSTALL_DIR"

    rollback_restore \
        "$BACKUP/config" \
        "$CONFIG_DIR"

    rollback_restore \
        "$BACKUP/cache" \
        "$CACHE_DIR"

    rollback_restore \
        "$BACKUP/state" \
        "$STATE_DIR"

    log_success "Rollback completed."

}