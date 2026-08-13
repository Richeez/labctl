#!/usr/bin/env bash

###############################################################################
# LABCTL Repair Command
###############################################################################

run() {

    case "${1:-}" in

        "")
            ;;

        --force)
            log_info "Force mode is not required for repair."
            ;;

        -h|--help)

            cat <<EOF

Usage:
  labctl repair

Repairs:
  NAT
  LAB
  BRIDGED
  NATNET

EOF

            return 0
            ;;

        *)
            log_error "Unknown repair option: $1"
            return "$EXIT_INVALID_ARGUMENT"
            ;;

    esac


    ###########################################################################
    # Transaction
    ###########################################################################

    transaction_begin || return "$EXIT_FAILURE"


    ###########################################################################
    # Repair
    ###########################################################################

    if workflow_begin REPAIR_WORKFLOW; then

        transaction_commit || {
            log_error "Failed to commit repair."
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