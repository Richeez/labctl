#!/usr/bin/env bash

###############################################################################
# Rollback
###############################################################################

system_rollback() {

    log_warning "Rolling back installation..."

    file_remove "$BIN_LINK"

    file_remove "$INSTALL_DIR"

    directory_remove "$CACHE_DIR"

    directory_remove "$STATE_DIR"

}