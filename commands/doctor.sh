#!/usr/bin/env bash

###############################################################################
# LABCTL Doctor
###############################################################################

run() {

    local FAILED=0
    local REPAIR=false

    [[ "${1:-}" == "--repair" ]] && REPAIR=true


    log_banner "PROFILE VALIDATION"

    profile_validate_all || ((++FAILED))

    #
    # Repair first
    #
    if $REPAIR; then

        echo
        log_banner "PROFILE REPAIR"

        profile_repair_all || ((++FAILED))

        echo
        log_info "Re-validating..."

        profile_validate_all || ((++FAILED))
    fi

    echo
    log_banner "HEALTH CHECKS"

    local CURRENT_PROFILE
    CURRENT_PROFILE="$(profile_current)"

    if [[ -z "$CURRENT_PROFILE" ]]; then
        log_error "No active profile."
        ((++FAILED))
    else
       verify_profile "$CURRENT_PROFILE" || ((++FAILED))
    fi

    echo

    if (( FAILED == 0 )); then
        log_success "Doctor completed successfully."
    else
        log_error "Doctor detected problems."
    fi

    return "$FAILED"

}

# run() {

#     local FAILED=0
#     local REPAIR=false

#     [[ "${1:-}" == "--repair" ]] && REPAIR=true

#     echo "ARG=$1"
#     echo "REPAIR=$REPAIR"

#     ###########################################################################
#     # Profile Validation
#     ###########################################################################

#     log_banner "PROFILE VALIDATION"

#     if ! profile_validate_all; then
#         ((++FAILED))
#     fi

#     ###########################################################################
#     # Repair
#     ###########################################################################

#     if $REPAIR; then

#         echo

#         log_banner "PROFILE REPAIR"

#         profile_repair_all

#         echo

#         log_info "Re-validating profiles..."

#         if profile_validate_all; then
#             log_success "Profile repair completed."
#         else
#             log_error "Profile repair failed."
#             return 1
#         fi

#     fi

#     ###########################################################################
#     # Health Checks
#     ###########################################################################

#     echo

#     log_banner "HEALTH CHECKS"

#     if ! verify_all; then
#         ((++FAILED))
#     fi

#     ###########################################################################
#     # Summary
#     ###########################################################################

#     echo

#     if (( FAILED == 0 )); then
#         log_success "Doctor completed successfully."
#         return 0
#     fi

#     log_error "Doctor detected problems."

#     if ! $REPAIR; then
#         echo
#         log_info "To automatically repair profile mappings run:"
#         echo
#         echo "    sudo labctl doctor --repair"
#     fi

#     return 1

# }