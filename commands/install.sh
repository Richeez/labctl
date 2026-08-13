#!/usr/bin/env bash

###############################################################################
# LABCTL Install Command
###############################################################################

run() {

    case "${1:-}" in

        "")
            ;;
        --force)
            log_error "--force is not implemented yet."
            return "$EXIT_INVALID_ARGUMENT"
            ;;
        *)
            log_error "Unknown install option: $1"
            return "$EXIT_INVALID_ARGUMENT"
            ;;

    esac


    ###########################################################################
    # Transaction
    ###########################################################################

    transaction_begin || return "$EXIT_FAILURE"


    ###########################################################################
    # Installation workflow
    ###########################################################################

    if workflow_begin INSTALL_WORKFLOW; then

        transaction_commit || {
            log_error "Failed to commit installation."
            return "$EXIT_FAILURE"
        }

        return "$EXIT_SUCCESS"

    fi


    ###########################################################################
    # Failure
    ###########################################################################

    transaction_abort || true

    return "$EXIT_FAILURE"

}