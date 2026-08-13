#!/usr/bin/env bash

###############################################################################
# NetworkManager Profile API
#
# Responsible for:
#   - Discovering profiles
#   - Activating profiles
#   - Deactivating profiles
#   - Finding attached devices
#   - Determining active status
###############################################################################

###############################################################################
# Profile Existence
###############################################################################

profile_exists() {

    local profile="$1"

    nmcli -t -f NAME connection show \
        | grep -Fxq "$profile"

}

###############################################################################
# Active Profile
###############################################################################


###############################################################################
# Configured Interface
###############################################################################

profile_interface() {

    local PROFILE="$1"

    nmcli -g connection.interface-name connection show "$PROFILE"

}

###############################################################################
# Activate Profile
###############################################################################

profile_activate() {

    local PROFILE="$1"

    log_info "Activating profile: $PROFILE"

    if ! nmcli connection up "$PROFILE" >/dev/null 2>&1
    then
        log_error "Failed to activate profile: $PROFILE"
        return 1
    fi

    log_success "$PROFILE activated."

}

###############################################################################
# Is Active
###############################################################################

profile_is_active() {

    local PROFILE="$1"

    profile_active | grep -Fxq "$PROFILE"

}

###############################################################################
# Device Bound To Profile
###############################################################################

profile_device() {

    local profile="$1"

    nmcli -t -f NAME,DEVICE connection show \
        | awk -F: -v p="$profile" '
            $1==p {
                print $2
                exit
            }
        '

}

profile_active_device() {

    local PROFILE="${1:-}"

    [[ -n "$PROFILE" ]] || return 1

    nmcli -t -f NAME,DEVICE connection show --active \
    | awk -F: -v p="$PROFILE" '
        $1 == p {
            print $2
            exit
        }
    '
}

wait_for_device() {

    local PROFILE="${1:-}"

    local i

    for ((i=0; i<10; i++)); do

        if [[ -n "$(profile_active_device "$PROFILE")" ]]; then
            return 0
        fi

        sleep 1
    done

    return 1
}

###############################################################################
# Wait For Profile Up
###############################################################################

wait_for_profile_up() {

    local PROFILE="$1"
    local TIMEOUT=10

    for ((i=0; i<TIMEOUT; i++)); do

        if profile_is_active "$PROFILE"; then
            return 0
        fi

        sleep 1

    done

    return 1

}

###############################################################################
# Wait For Profile Down
###############################################################################

wait_for_profile_down() {

    local PROFILE="$1"
    local TIMEOUT=10

    for ((i=0; i<TIMEOUT; i++)); do

        if ! profile_is_active "$PROFILE"; then
            return 0
        fi

        sleep 1

    done

    return 1

}

###############################################################################
# Activate Profile
###############################################################################

profile_active() {

    nmcli -t -f NAME connection show --active 2>/dev/null \
        | awk '$0 != "lo" && NF'

}
###############################################################################
# Current Managed Profile
###############################################################################

profile_current() {

    local ACTIVE
    local PROFILE

    ACTIVE="$(profile_active)"

    while IFS= read -r PROFILE; do

        if grep -Fxq "$PROFILE" <<< "$ACTIVE"; then
            printf '%s\n' "$PROFILE"
            return 0
        fi

    done < <(profile_list)

    return 1
}

###############################################################################
# Deactivate Profile
###############################################################################

profile_deactivate() {

    local PROFILE="$1"

    profile_is_active "$PROFILE" || return 0

    log_info "Disconnecting profile: $PROFILE"

    if ! nmcli connection down "$PROFILE" >/dev/null 2>&1
    then
        log_error "Failed to disconnect $PROFILE"
        return 1
    fi

    log_success "$PROFILE disconnected."

}

###############################################################################
# Deactivate All Managed Profiles
###############################################################################

profile_deactivate_all() {

    local PROFILE

    while IFS= read -r PROFILE
    do
        profile_is_active "$PROFILE" || continue
        profile_deactivate "$PROFILE"
    done < <(profile_list)

}


wait_for_profile() {

    local PROFILE="$1"

    for ((i=0; i<10; i++)); do

        [[ "$(state_profile)" == "$PROFILE" ]] && return 0

        sleep 1

    done

    return 1

}

###############################################################################
# Activate Only One Profile
###############################################################################

profile_activate_only() {

    local TARGET="$1"
    local CURRENT

    CURRENT="$(state_profile)"

    #
    # Already active
    #
    if [[ "$CURRENT" == "$TARGET" ]]; then
        log_info "$TARGET is already active."
        return 0
    fi

    log_info "Current profile : ${CURRENT:-None}"
    log_info "Target profile  : $TARGET"

    #
    # Disconnect current profile
    #
    if [[ -n "$CURRENT" ]]; then

        if ! profile_deactivate "$CURRENT"; then
            log_error "Failed to disconnect '$CURRENT'."
            return 1
        fi

    fi

    #
    # Activate target profile
    #
    if ! profile_activate "$TARGET"; then

        log_error "Failed to activate '$TARGET'."

        rollback_profile "$CURRENT"

        return 1

    fi

    #
    # Wait for NetworkManager to mark the profile active
    #
    if ! wait_for_profile "$TARGET"; then

        log_error "Timed out waiting for '$TARGET' to become active."

        rollback_profile "$CURRENT"

        return 1

    fi

    #
    # Wait until the active connection has a device
    #
    if ! wait_for_device "$TARGET"; then

        log_error "No active device found for '$TARGET'."

        rollback_profile "$CURRENT"

        return 1

    fi

    #
    # Verify the profile is actually usable
    #
    if ! verify_profile "$TARGET"; then

        log_error "Verification failed."

        rollback_profile "$CURRENT"

        return 1

    fi

    refresh_state

    snapshot_create

    log_success "Switched to $TARGET."

    return 0
}


rollback_profile() {

    local PROFILE="$1"

    [[ -z "$PROFILE" ]] && return 1

    log_warning "Rolling back..."

    if profile_activate "$PROFILE"; then

        wait_for_profile "$PROFILE"

        log_success "Rollback successful."

        return 0

    fi

    log_error "Rollback failed."

    return 1

}


###############################################################################
# Print Managed Profiles
###############################################################################

profile_list() {

    printf "%s\n" \
        "$PROFILE_NAT" \
        "$PROFILE_NATNET" \
        "$PROFILE_LAB" \
        "$PROFILE_BRIDGED"

}


###############################################################################
# Expected Interface Mapping
###############################################################################

profile_expected_device() {

    case "$1" in
        "$PROFILE_NAT")      echo "eth1" ;;
        "$PROFILE_LAB")      echo "eth2" ;;
        "$PROFILE_BRIDGED")  echo "eth3" ;;
        "$PROFILE_NATNET")   echo "eth0" ;;
        *) return 1 ;;
    esac

}


###############################################################################
# Validate Profile
###############################################################################

profile_validate() {

    local PROFILE="$1"

    local EXPECTED
    local ACTUAL

    EXPECTED="$(profile_expected_device "$PROFILE")"
    ACTUAL="$(profile_interface "$PROFILE")"

    [[ "$EXPECTED" == "$ACTUAL" ]]

}


###############################################################################
# Validate All Profiles
###############################################################################

profile_validate_all() {

    local PROFILE
    local EXPECTED
    local ACTUAL
    local FAILED=0

    printf "%-10s %-10s %-10s %-10s\n" \
        "PROFILE" \
        "EXPECTED" \
        "ACTUAL" \
        "STATUS"

    printf "%-10s %-10s %-10s %-10s\n" \
        "--------" \
        "--------" \
        "------" \
        "------"

    while IFS= read -r PROFILE
    do

        EXPECTED="$(profile_expected_device "$PROFILE")"
        ACTUAL="$(profile_interface "$PROFILE")"

        if [[ "$EXPECTED" == "$ACTUAL" ]]; then

            printf "%-10s %-10s %-10s %-10s\n" \
                "$PROFILE" \
                "$EXPECTED" \
                "$ACTUAL" \
                "OK"

        else

            printf "%-10s %-10s %-10s %-10s\n" \
                "$PROFILE" \
                "$EXPECTED" \
                "${ACTUAL:--}" \
                "FAIL"

            ((++FAILED))

        fi

    done < <(profile_list)

    return "$FAILED"

}


###############################################################################
# Repair Profile Mapping
###############################################################################

profile_repair() {

    local PROFILE="$1"
    local EXPECTED

    EXPECTED="$(profile_expected_device "$PROFILE")"

    log_info "Binding '$PROFILE' to '$EXPECTED'..."

    nmcli connection modify \
        "$PROFILE" \
        connection.interface-name "$EXPECTED"

}


###############################################################################
# Repair All Profiles
###############################################################################

profile_repair_all() {

    local PROFILE

    while IFS= read -r PROFILE
    do
        log_info "Repairing profile: $PROFILE"

        if profile_repair "$PROFILE"; then
            log_success "$PROFILE repaired."
        else
            log_error "$PROFILE repair failed."
        fi

    done < <(profile_list)

}