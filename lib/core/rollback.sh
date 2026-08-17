#!/usr/bin/env bash

###############################################################################
# LABCTL Rollback
###############################################################################

rollback_transaction() {

    local TRANSACTION_DIR="$1"

    [[ -d "$TRANSACTION_DIR" ]] || return 0

    log_info "Restoring transaction backup..."

    if [[ -x "$TRANSACTION_DIR/rollback.sh" ]]; then

        "$TRANSACTION_DIR/rollback.sh"

        return $?

    fi

    if [[ -d "$TRANSACTION_DIR/backup/application" ]]; then
        log_info "Restoring application backup..."
        rm -rf "$INSTALL_DIR" || return "$EXIT_FAILURE"
        cp -a "$TRANSACTION_DIR/backup/application" "$INSTALL_DIR" || return "$EXIT_FAILURE"
    fi

    if [[ -f "$TRANSACTION_DIR/backup/config.conf" ]]; then
        log_info "Restoring configuration backup..."
        mkdir -p "$CONFIG_DIR" || return "$EXIT_FAILURE"
        cp -a "$TRANSACTION_DIR/backup/config.conf" "$CONFIG_FILE" || return "$EXIT_FAILURE"
    fi

    return 0

}
