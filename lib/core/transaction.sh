#!/usr/bin/env bash

###############################################################################
# LABCTL Transaction Manager
###############################################################################

TRANSACTION_ACTIVE=false
TRANSACTION_BACKUP_CREATED=false
TRANSACTION_ID=""
T_DIR=""
TRANSACTION_CREATED_DIRS=()


###############################################################################
# Begin
###############################################################################

transaction_begin() {

    if [[ "$TRANSACTION_ACTIVE" == true ]]; then

        log_error "A transaction is already active."

        return "$EXIT_FAILURE"

    fi


    ###########################################################################
    # Reset transaction state
    ###########################################################################

    TRANSACTION_ID="$(
        date '+%Y%m%d%H%M%S'
    )"

    T_DIR="$TRANSACTION_DIR/$TRANSACTION_ID"

    TRANSACTION_BACKUP_CREATED=false


    ###########################################################################
    # Create transaction directory
    ###########################################################################

    if ! mkdir -p "$T_DIR"; then

        log_error "Unable to create transaction directory."

        TRANSACTION_ID=""
        T_DIR=""

        return "$EXIT_FAILURE"

    fi


    ###########################################################################
    # Mark transaction active
    ###########################################################################

    TRANSACTION_ACTIVE=true


    ###########################################################################
    # Persist current transaction
    ###########################################################################

    if ! printf '%s\n' "$TRANSACTION_ID" \
        > "$STATE_DIR/transactions/current"; then

        log_error "Unable to record active transaction."

        rm -rf "$T_DIR"

        TRANSACTION_ACTIVE=false
        TRANSACTION_ID=""
        T_DIR=""

        return "$EXIT_FAILURE"

    fi


    log_info "Transaction started."

    return "$EXIT_SUCCESS"

}


###############################################################################
# Register Backup
###############################################################################

transaction_backup_created() {

    if [[ "$TRANSACTION_ACTIVE" != true ]]; then

        log_error "No active transaction."

        return "$EXIT_FAILURE"

    fi

    TRANSACTION_BACKUP_CREATED=true

    return "$EXIT_SUCCESS"

}


###############################################################################
# Commit
###############################################################################

transaction_commit() {

    if [[ "$TRANSACTION_ACTIVE" != true ]]; then
        return "$EXIT_SUCCESS"
    fi


    ###########################################################################
    # Remove active transaction marker
    ###########################################################################

    rm -f \
        "$STATE_DIR/transactions/current"


    ###########################################################################
    # Remove transaction directory
    ###########################################################################

    if [[ -n "$T_DIR" ]]; then

        rm -rf \
            "$T_DIR"

    fi


    ###########################################################################
    # Reset transaction state
    ###########################################################################

    TRANSACTION_ACTIVE=false
    TRANSACTION_BACKUP_CREATED=false
    TRANSACTION_ID=""
    T_DIR=""


    log_success "Transaction committed."

    return "$EXIT_SUCCESS"

}


###############################################################################
# Abort
###############################################################################

transaction_abort() {

    if [[ "$TRANSACTION_ACTIVE" != true ]]; then
        return "$EXIT_SUCCESS"
    fi

    log_error "Transaction failed."


    ###########################################################################
    # Restore previous installation
    ###########################################################################

    if [[ "$TRANSACTION_BACKUP_CREATED" == true ]]; then

        if ! rollback_transaction "$T_DIR"; then

            log_error "Rollback failed."

            return "$EXIT_FAILURE"

        fi

    else

        log_info "No previous installation found."

        #######################################################################
        # Fresh installation rollback
        #######################################################################

        if [[ -d "$INSTALL_DIR" ]]; then

            log_info "Removing incomplete installation."

            rm -rf "$INSTALL_DIR" || {

                log_error "Failed to remove incomplete installation."

                return "$EXIT_FAILURE"

            }

        fi

    fi


    ###########################################################################
    # Remove transaction-created directories
    ###########################################################################

    transaction_rollback_directories || {

        log_error "Failed to rollback created directories."

        return "$EXIT_FAILURE"

    }


    ###########################################################################
    # Remove transaction state
    ###########################################################################

    rm -f "$STATE_DIR/transactions/current"

    rm -rf "$T_DIR"


    ###########################################################################
    # Reset state
    ###########################################################################

    TRANSACTION_ACTIVE=false
    TRANSACTION_BACKUP_CREATED=false
    TRANSACTION_ID=""
    T_DIR=""
    TRANSACTION_CREATED_DIRS=()


    return "$EXIT_FAILURE"
}


###############################################################################
# Active Status
###############################################################################

transaction_active() {

    [[ "$TRANSACTION_ACTIVE" == true ]]

}


###############################################################################
# Backup Status
###############################################################################

transaction_has_backup() {

    [[ "$TRANSACTION_BACKUP_CREATED" == true ]]

}


###############################################################################
# Transaction ID
###############################################################################

transaction_id() {

    printf '%s\n' "$TRANSACTION_ID"

}


###############################################################################
# Transaction Directory
###############################################################################

transaction_dir() {

    printf '%s\n' "$T_DIR"

}

transaction_track_directory() {

    local DIRECTORY="$1"

    [[ -d "$DIRECTORY" ]] || return "$EXIT_SUCCESS"

    TRANSACTION_CREATED_DIRS+=("$DIRECTORY")

}

transaction_rollback_directories() {

    local DIRECTORY

    for DIRECTORY in "${TRANSACTION_CREATED_DIRS[@]}"; do

        if [[ -d "$DIRECTORY" ]]; then

            log_info "Removing: $DIRECTORY"

            rm -rf "$DIRECTORY" || {

                log_error "Failed to remove: $DIRECTORY"

                return "$EXIT_FAILURE"

            }

        fi

    done

    return "$EXIT_SUCCESS"

}