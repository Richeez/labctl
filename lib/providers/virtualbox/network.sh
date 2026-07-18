#!/bin/bash

###############################################################################
# Network Provider
#
# NetworkManager implementation.
###############################################################################

declare -A LABCTL_CONNECTIONS=(
    [update]="$UPDATE_CONN"
    [lab]="$LAB_CONN"
    [bridged]="$BRIDGED_CONN"
    [contain]="$CONTAIN_CONN"
)

switch_provider_activate() {

    local MODE="$1"

    local PROFILE="${LABCTL_CONNECTIONS[$MODE]}"

    [[ -n "$PROFILE" ]] || fatal "Unknown mode: $MODE"

    info "Switching to profile: $PROFILE"

    for CONN in "${LABCTL_CONNECTIONS[@]}"
    do
        nmcli connection down "$CONN" >/dev/null 2>&1 || true
    done

    nmcli connection up "$PROFILE"

    sleep 2

    json_set ".mode=\"$MODE\""
    json_set ".last_switch=\"$(timestamp)\""

    event_emit "NETWORK_CHANGED" "$MODE"
}

switch_provider_reset() {

    nmcli networking off

    sleep 2

    nmcli networking on

}