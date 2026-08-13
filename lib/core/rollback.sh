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

    log_info "No rollback actions registered."

    return 0

}