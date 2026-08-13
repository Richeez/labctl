#!/usr/bin/env bash

###############################################################################
# Installer Backup
###############################################################################

backup_create() {

    transaction_active || {
        log_error "No active transaction."
        return "$EXIT_FAILURE"
    }

    local BACKUP_DIR="$TRANSACTION_DIR/backup"
    local BACKUP_CREATED=false

    mkdir -p "$BACKUP_DIR" || {
        log_error "Unable to create backup directory."
        return "$EXIT_FAILURE"
    }

    if [[ -d "$INSTALL_DIR" ]]; then

        cp -a \
            "$INSTALL_DIR" \
            "$BACKUP_DIR/application" || {
                log_error "Failed to backup application."
                return "$EXIT_FAILURE"
            }

        BACKUP_CREATED=true

    fi

    if [[ -f "$CONFIG_FILE" ]]; then

        cp -a \
            "$CONFIG_FILE" \
            "$BACKUP_DIR/config.conf" || {
                log_error "Failed to backup configuration."
                return "$EXIT_FAILURE"
            }

        BACKUP_CREATED=true

    fi

    if [[ "$BACKUP_CREATED" == true ]]; then

        transaction_backup_created

    else

        log_info "No existing installation or configuration to backup."

    fi

    return "$EXIT_SUCCESS"
}

# backup_create() {

#     transaction_active || {

#         log_error "No active transaction."

#         return "$EXIT_FAILURE"

#     }


#     local BACKUP_DIR="$TRANSACTION_DIR/backup"


#     ###########################################################################
#     # Create backup directory
#     ###########################################################################

#     if ! mkdir -p "$BACKUP_DIR"; then

#         log_error "Unable to create backup directory."

#         return "$EXIT_FAILURE"

#     fi


#     ###########################################################################
#     # Backup existing application
#     ###########################################################################

#     if [[ -d "$INSTALL_DIR" ]]; then

#         if ! cp -a \
#             "$INSTALL_DIR" \
#             "$BACKUP_DIR/application"; then

#             log_error "Failed to backup application."

#             return "$EXIT_FAILURE"

#         fi

#     fi


#     ###########################################################################
#     # Backup configuration
#     ###########################################################################

#     if [[ -f "$CONFIG_FILE" ]]; then

#         if ! cp -a \
#             "$CONFIG_FILE" \
#             "$BACKUP_DIR/config.conf"; then

#             log_error "Failed to backup configuration."

#             return "$EXIT_FAILURE"

#         fi

#     fi


#     ###########################################################################
#     # Mark backup as created
#     ###########################################################################

#     transaction_backup_created

# }

backup_latest() {

    ls -td "$BACKUP_ROOT"/* 2>/dev/null | head -1

}