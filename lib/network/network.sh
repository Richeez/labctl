#!/usr/bin/env bash

###############################################################################
# Network Service
###############################################################################

###############################################################################
# Switch Profile
###############################################################################

network_switch() {

    local profile="$1"

    if ! profile_exists "$profile"; then
        log_error "Profile '$profile' does not exist."
        return 1
    fi

    if profile_is_active "$profile"; then
        log_info "$profile is already active."
        return 0
    fi

    log_info "Switching network profile..."

    profile_activate_only "$profile" || return 1

    log_success "Switched to $profile."

}

network_update() {

    network_switch "$PROFILE_NAT"

}

network_contain() {

    network_switch "$PROFILE_NATNET"

}

network_lab() {

    network_switch "$PROFILE_LAB"

}

network_bridged() {

    network_switch "$PROFILE_BRIDGED"

}

network_current_profile() {

    while IFS= read -r profile; do

        if profile_is_active "$profile"; then
            printf "%s\n" "$profile"
            return 0
        fi

    done < <(profile_list)

    return 1

}