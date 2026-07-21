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

profile_active() {

    nmcli -t -f NAME connection show --active

}

###############################################################################
# Is Active
###############################################################################

profile_is_active() {

    local profile="$1"

    profile_active | grep -Fxq "$profile"

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

###############################################################################
# Activate Profile
###############################################################################

profile_activate() {

    local profile="$1"

    log_info "Activating profile: $profile"

    if ! nmcli connection up "$profile" >/dev/null; then
        log_error "Failed to activate profile: $profile"
        return 1
    fi

    log_success "$profile activated."

}

###############################################################################
# Deactivate Profile
###############################################################################

profile_deactivate() {

    local profile="$1"

    if profile_is_active "$profile"; then

    log_info "Disconnecting profile: $profile"

    if ! nmcli connection down "$profile" >/dev/null; then
        log_warning "Unable to disconnect $profile"
        return 1
    fi

    log_success "$profile disconnected."

fi

}

###############################################################################
# Deactivate All Managed Profiles
###############################################################################

profile_deactivate_all() {

    local profiles=(
        "$PROFILE_NAT"
        "$PROFILE_NATNET"
        "$PROFILE_LAB"
        "$PROFILE_BRIDGED"
    )

    local profile

    for profile in "${profiles[@]}"
    do
        profile_deactivate "$profile"
    done

}

###############################################################################
# Activate Only One Profile
###############################################################################

profile_activate_only() {

    local profile="$1"

    profile_deactivate_all || return 1

    profile_activate "$profile" || return 1

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