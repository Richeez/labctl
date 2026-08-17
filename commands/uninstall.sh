#!/usr/bin/env bash

###############################################################################
# LABCTL Uninstall Command
###############################################################################

run() {

    local PURGE=false


    ###########################################################################
    # Arguments
    ###########################################################################

    while (($#)); do

        case "$1" in

            --purge)
                PURGE=true
                ;;

            -h|--help)

                cat <<EOF
Usage:
  labctl uninstall
  labctl uninstall --purge

Options:
  --purge      Remove application, cache, state, logs and configuration.
  -h, --help   Show this help.

EOF

                return "$EXIT_SUCCESS"
                ;;

            *)
                log_error "Unknown uninstall option: $1"

                return "$EXIT_INVALID_ARGUMENT"
                ;;

        esac

        shift

    done

    install_assert_root || return $?


    ###########################################################################
    # Transaction
    ###########################################################################

    transaction_begin || {

        log_error "Unable to start uninstall transaction."

        return "$EXIT_FAILURE"

    }


    ###########################################################################
    # Backup
    ###########################################################################

    if ! backup_create; then

        log_error "Unable to create uninstall backup."

        transaction_abort || true

        return "$EXIT_FAILURE"

    fi


    ###########################################################################
    # Select workflow
    ###########################################################################

    local -a UNINSTALL_STEPS=(
        "${UNINSTALL_WORKFLOW[@]}"
    )


    if [[ "$PURGE" == true ]]; then

        UNINSTALL_STEPS+=(
            "Clearing logs:logs_clear"
            "Removing configuration:install_config_remove"
        )

    fi


    ###########################################################################
    # Execute workflow
    ###########################################################################

    if ! workflow_begin UNINSTALL_STEPS; then

        log_error "Uninstall failed."

        transaction_abort || true

        return "$EXIT_FAILURE"

    fi


    ###########################################################################
    # Commit
    ###########################################################################

    if ! transaction_commit; then

        log_error "Failed to commit uninstall."

        transaction_abort || true

        return "$EXIT_FAILURE"

    fi


    ###########################################################################
    # Success
    ###########################################################################

    log_success "LABCTL uninstall completed successfully."

    return "$EXIT_SUCCESS"
}

# run() {

#     local PURGE=false


#     ###########################################################################
#     # Arguments
#     ###########################################################################

#     while (($#)); do

#         case "$1" in

#             --purge)
#                 PURGE=true
#                 ;;

#             -h|--help)

#                 cat <<EOF

# Usage:
#   labctl uninstall
#   labctl uninstall --purge

# Options:
#   --purge    Remove application, cache, state, logs and configuration.
#   -h, --help Show this help.

# EOF

#                 return 0
#                 ;;

#             *)
#                 log_error "Unknown uninstall option: $1"
#                 return "$EXIT_INVALID_ARGUMENT"
#                 ;;

#         esac

#         shift

#     done


#     ###########################################################################
#     # Transaction
#     ###########################################################################

#     transaction_begin || return "$EXIT_FAILURE"


#     ###########################################################################
#     # Backup
#     ###########################################################################

#     if ! backup_create; then

#         log_error "Unable to create uninstall backup."

#         transaction_abort || true

#         return "$EXIT_FAILURE"

#     fi


#     ###########################################################################
#     # Select workflow
#     ###########################################################################

#     if [[ "$PURGE" == true ]]; then

#         local -a WORKFLOW=(

#             "${UNINSTALL_WORKFLOW[@]}"

#             "Clearing logs:logs_clear"

#             "Removing configuration:config_remove"

#         )

#     else

#         local -a WORKFLOW=(
#             "${UNINSTALL_WORKFLOW[@]}"
#         )

#     fi


#     ###########################################################################
#     # Execute
#     ###########################################################################

#     if workflow_begin WORKFLOW; then

#         transaction_commit || {
#             log_error "Failed to commit uninstall."
#             return "$EXIT_FAILURE"
#         }

#         return "$EXIT_SUCCESS"

#     fi


#     ###########################################################################
#     # Failure
#     ###########################################################################

#     transaction_abort || true

#     return "$EXIT_FAILURE"

# }


# run() {

#     transaction_begin || return 1

#     backup_create || {
#         transaction_abort || true
#         return 1
#     }

#     if workflow_begin UNINSTALL_WORKFLOW; then

#         transaction_commit || return 1

#         return 0

#     fi

#     transaction_abort || true

#     return 1

# }
