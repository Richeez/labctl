#!/usr/bin/env bash

###############################################################################
# Installer Transactions
###############################################################################

TRANSACTION_ACTIVE=false
TRANSACTION_ID=""
TRANSACTION_START=""
TRANSACTION_SUCCESS=false

transaction_begin() {

    TRANSACTION_ACTIVE=true
    TRANSACTION_SUCCESS=false
    TRANSACTION_ID="$(uuidgen 2>/dev/null || date +%s)"
    TRANSACTION_START="$(date +%s)"

    log_info "Transaction started."

}

transaction_commit() {

    TRANSACTION_SUCCESS=true
    TRANSACTION_ACTIVE=false

    log_success "Transaction committed."

}

transaction_abort() {

    [[ "$TRANSACTION_ACTIVE" == true ]] || return 0

    rollback_run

    TRANSACTION_ACTIVE=false

}