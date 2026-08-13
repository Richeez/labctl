#!/usr/bin/env bash

###############################################################################
# LABCTL Doctor
###############################################################################


run() {

    local REPAIR=false
    local FAILED=0


    ###########################################################################
    # Arguments
    ###########################################################################

    while (($#)); do

        case "$1" in

            --repair)

                REPAIR=true
                ;;


            -h|--help)

                cat <<EOF
Usage:
  labctl doctor
  labctl doctor --repair

Options:
  --repair      Detect and repair problems.
  -h, --help    Show this help.

EOF

                return "$EXIT_SUCCESS"
                ;;


            *)

                log_error "Unknown doctor option: $1"

                return "$EXIT_INVALID_ARGUMENT"
                ;;

        esac

        shift

    done


    ###########################################################################
    # Prepare
    ###########################################################################

    cache_ensure || {

        log_error "Unable to initialize cache."

        return "$EXIT_FAILURE"

    }


    ###########################################################################
    # Start Doctor
    ###########################################################################

    ui_start "LABCTL DOCTOR"


    ###########################################################################
    # Profile validation
    ###########################################################################

    echo

    log_banner "PROFILE CHECK"


    if profile_validate_all; then

        log_success "Profile validation passed."

    else

        ((++FAILED))

        log_error "Profile validation failed."

    fi


    ###########################################################################
    # Repair
    ###########################################################################

    if [[ "$REPAIR" == true ]]; then

        #######################################################################
        # Nothing to repair
        #######################################################################

        if (( FAILED == 0 )); then

            log_success "No profile problems require repair."

        else

            echo

            log_banner "PROFILE REPAIR"


            ###################################################################
            # Begin transaction
            ###################################################################

            transaction_begin || {

                log_error "Unable to start repair transaction."

                ui_finish

                return "$EXIT_FAILURE"

            }


            ###################################################################
            # Create transaction backup
            ###################################################################

            if ! backup_create; then

                log_error "Unable to create repair backup."

                transaction_abort || true

                ui_finish

                return "$EXIT_FAILURE"

            fi


            ###################################################################
            # Repair profiles
            ###################################################################

            if ! profile_repair_all; then

                log_error "Profile repair failed."

                transaction_abort || true

                ui_finish

                return "$EXIT_FAILURE"

            fi


            ###################################################################
            # Revalidate profiles
            ###################################################################

            echo

            log_info "Re-validating profiles..."


            if ! profile_validate_all; then

                log_error "Profile repair did not resolve all profile problems."

                transaction_abort || true

                ui_finish

                return "$EXIT_FAILURE"

            fi


            ###################################################################
            # Commit repair
            ###################################################################

            if ! transaction_commit; then

                log_error "Failed to commit profile repair."

                transaction_abort || true

                ui_finish

                return "$EXIT_FAILURE"

            fi


            ###################################################################
            # Reset failure count
            #
            # The original profile failures have now been repaired,
            # successfully revalidated, and committed.
            ###################################################################

            FAILED=0


            log_success "Profile repair completed successfully."

        fi

    fi


    ###########################################################################
    # Health checks
    ###########################################################################

    echo

    log_banner "HEALTH CHECKS"


    ###########################################################################
    # Active profile
    ###########################################################################

    local CURRENT_PROFILE

    CURRENT_PROFILE="$(state_profile)"


    if [[ -z "$CURRENT_PROFILE" ]]; then

        log_error "No active profile."

        ((++FAILED))

    else

        log_info "Active profile: $CURRENT_PROFILE"


        #######################################################################
        # Profile verification
        #######################################################################

        if ! verify_profile "$CURRENT_PROFILE"; then

            ((++FAILED))

        fi

    fi


    ###########################################################################
    # NetworkManager
    ###########################################################################

    if ! verify_networkmanager; then

        ((++FAILED))

    fi


    ###########################################################################
    # Interfaces
    ###########################################################################

    if ! verify_interface; then

        ((++FAILED))

    fi


    ###########################################################################
    # Default route
    ###########################################################################

    if ! verify_default_route; then

        ((++FAILED))

    fi


    ###########################################################################
    # Gateway
    ###########################################################################

    if ! verify_gateway; then

        ((++FAILED))

    fi


    ###########################################################################
    # DNS
    ###########################################################################

    if ! verify_dns; then

        ((++FAILED))

    fi


    ###########################################################################
    # Internet
    ###########################################################################

    if ! verify_internet; then

        ((++FAILED))

    fi


    ###########################################################################
    # Result
    ###########################################################################

    echo


    if (( FAILED == 0 )); then

        log_success "Doctor completed successfully."

        ui_finish

        return "$EXIT_SUCCESS"

    fi


    log_error "Doctor detected $FAILED problem(s)."

    ui_finish

    return "$EXIT_FAILURE"
}



# run() {

#     local REPAIR=false


#     ###########################################################################
#     # Arguments
#     ###########################################################################

#     while (($#)); do

#         case "$1" in

#             --repair)

#                 REPAIR=true
#                 ;;


#             -h|--help)

#                 cat <<EOF

# Usage:
#   labctl doctor
#   labctl doctor --repair

# Options:
#   --repair     Detect and repair problems.
#   -h, --help   Show this help.

# EOF

#                 return "$EXIT_SUCCESS"
#                 ;;


#             *)

#                 log_error "Unknown doctor option: $1"

#                 return "$EXIT_INVALID_ARGUMENT"
#                 ;;

#         esac

#         shift

#     done


#     ###########################################################################
#     # Normal doctor
#     ###########################################################################

#     if [[ "$REPAIR" == false ]]; then

#         workflow_begin DOCTOR_WORKFLOW true

#         return $?

#     fi


#     ###########################################################################
#     # Initial validation
#     #
#     # Doctor is allowed to find problems here.
#     # The result determines whether repair is necessary.
#     ###########################################################################

#     local INITIAL_STATUS=0

#     workflow_begin DOCTOR_WORKFLOW true || INITIAL_STATUS=$?


#     ###########################################################################
#     # Healthy system
#     #
#     # Nothing needs to be repaired.
#     ###########################################################################

#     if (( INITIAL_STATUS == 0 )); then

#         log_success "No problems detected."

#         return "$EXIT_SUCCESS"

#     fi


#     ###########################################################################
#     # Begin repair transaction
#     ###########################################################################

#     transaction_begin || {

#         log_error "Unable to start repair transaction."

#         return "$EXIT_FAILURE"

#     }


#     ###########################################################################
#     # Create transaction backup
#     ###########################################################################

#     if ! backup_create; then

#         log_error "Unable to create repair backup."

#         transaction_abort || true

#         return "$EXIT_FAILURE"

#     fi


#     ###########################################################################
#     # Repair
#     ###########################################################################

#     if ! workflow_begin REPAIR_WORKFLOW; then

#         log_error "Repair failed."

#         transaction_abort || true

#         return "$EXIT_FAILURE"

#     fi


#     ###########################################################################
#     # Re-validation
#     #
#     # The repaired system must pass ALL doctor checks.
#     ###########################################################################

#     if ! workflow_begin DOCTOR_WORKFLOW true; then

#         log_error "Repair completed but validation still reports problems."

#         transaction_abort || true

#         return "$EXIT_FAILURE"

#     fi


#     ###########################################################################
#     # Commit
#     ###########################################################################

#     if ! transaction_commit; then

#         log_error "Failed to commit repair."

#         transaction_abort || true

#         return "$EXIT_FAILURE"

#     fi


#     ###########################################################################
#     # Success
#     ###########################################################################

#     log_success "Doctor repair completed successfully."

#     return "$EXIT_SUCCESS"

# }


# run() {

#     cache_ensure

#     local FAILED=0
#     local REPAIR=false

#     [[ "${1:-}" == "--repair" ]] && REPAIR=true


#     ui_start "LABCTL DOCTOR"

#     profile_validate_all || ((++FAILED))

#     #
#     # Repair first
#     #
#     if $REPAIR; then

#         echo
#         log_banner "PROFILE REPAIR"

#         profile_repair_all || ((++FAILED))

#         echo
#         log_info "Re-validating..."

#         profile_validate_all || ((++FAILED))
#     fi

#     echo
#     log_banner "HEALTH CHECKS"

#     local CURRENT_PROFILE
#     CURRENT_PROFILE="$(state_profile)"

#     if [[ -z "$CURRENT_PROFILE" ]]; then
#         log_error "No active profile."
#         ((++FAILED))
#     else
#        verify_profile "$CURRENT_PROFILE" || ((++FAILED))
#     fi

#     echo

#     if (( FAILED == 0 )); then
#         log_success "Doctor completed successfully."
#     else
#         log_error "Doctor detected problems."
#     fi

#     ui_finish

#     return "$FAILED"

# }
