#!/usr/bin/env bash

###############################################################################
# NetworkManager Profile Functions
###############################################################################

profile_exists() {

    local PROFILE="$1"

    nmcli -t -f NAME connection show | grep -Fxq "$PROFILE"

}

profile_is_active() {

    local PROFILE="$1"

    nmcli -t -f NAME connection show --active | grep -Fxq "$PROFILE"

}

profile_activate() {

    local PROFILE="$1"

    profile_exists "$PROFILE" \
        || fatal "Network profile '$PROFILE' does not exist."

    info "Activating profile: $PROFILE"

    nmcli connection up "$PROFILE" >/dev/null

}

profile_deactivate() {

    local PROFILE="$1"

    profile_exists "$PROFILE" || return

    nmcli connection down "$PROFILE" >/dev/null 2>&1 || true

}

profile_deactivate_all() {

    profile_deactivate "$PROFILE_UPDATE"
    profile_deactivate "$PROFILE_LAB"
    profile_deactivate "$PROFILE_BRIDGED"
    profile_deactivate "$PROFILE_CONTAIN"

}