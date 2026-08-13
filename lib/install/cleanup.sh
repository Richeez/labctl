#!/usr/bin/env bash

###############################################################################
# LABCTL Cleanup
###############################################################################

cleanup_cache() {

    if [[ ! -d "$CACHE_DIR" ]]; then
        return 0
    fi

    find "$CACHE_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -exec rm -rf -- {} +

    log_success "Cache cleared."

}


cleanup_logs() {

    logs_clear

}


cleanup_state() {

    if [[ ! -d "$STATE_DIR" ]]; then
        return 0
    fi

    find "$STATE_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        ! -path "$STATE_DIR/backups" \
        -exec rm -rf -- {} +

    log_success "Runtime state cleared."

}

cleanup_directories() {

    rmdir "$INSTALL_DIR" 2>/dev/null || true

    rmdir "$CONFIG_DIR" 2>/dev/null || true

    rmdir "$STATE_DIR" 2>/dev/null || true

    rmdir "$CACHE_DIR" 2>/dev/null || true

    rmdir "$LOG_DIR" 2>/dev/null || true

}


cleanup_all() {

    cleanup_cache
    cleanup_logs
    cleanup_state
    cleanup_directories

}

