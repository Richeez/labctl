#!/usr/bin/env bash

###############################################################################
# LABCTL Update
###############################################################################

#!/usr/bin/env bash

###############################################################################
# LABCTL Update Command
###############################################################################

run() {

    case "${1:-}" in

        "")
            ;;

        --backup)
            log_info "Backup is automatically created during update."
            ;;

        -h|--help)
            cat <<EOF
Usage: labctl update [--backup]

Refresh the installed files from the current LABCTL checkout and preserve the
existing configuration. A rollback backup is created automatically.

Options:
  --backup      Accepted for compatibility; backups are always created.
  -h, --help    Show this help.
EOF
            return "$EXIT_SUCCESS"
            ;;

        *)
            log_error "Unknown update option: $1"
            return "$EXIT_INVALID_ARGUMENT"
            ;;

    esac

    install_assert_root || return $?

    install_assert_installed || return $?


    ###########################################################################
    # Transaction
    ###########################################################################

    transaction_begin || return "$EXIT_FAILURE"


    ###########################################################################
    # Backup
    ###########################################################################

    if ! backup_create; then

        log_error "Unable to create update backup."

        transaction_abort || true

        return "$EXIT_FAILURE"

    fi


    ###########################################################################
    # Update workflow
    ###########################################################################

    if workflow_begin UPDATE_WORKFLOW; then

        transaction_commit || {
            log_error "Failed to commit update."
            return "$EXIT_FAILURE"
        }

        update_summary

        return "$EXIT_SUCCESS"

    fi


    ###########################################################################
    # Failure
    ###########################################################################

    transaction_abort || true

    return "$EXIT_FAILURE"

}

# run() {

#     transaction_begin || return 1

#     if workflow_begin UPDATE_WORKFLOW; then

#         transaction_commit || return 1

#         return 0

#     fi

#     transaction_abort || true

#     return 1

# }
