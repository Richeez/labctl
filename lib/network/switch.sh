#!/bin/bash

###############################################################################
# Network Switching Engine
###############################################################################

declare -A CONNECTIONS=(
    [update]=UPDATE_CONN
    [lab]=LAB_CONN
    [bridged]=BRIDGED_CONN
    [contain]=CONTAIN_CONN
)

activate_connection() {

    local TARGET="$1"

    local PROFILE="${CONNECTIONS[$TARGET]}"

    [[ -n "$PROFILE" ]] || fatal "Unknown profile: $TARGET"

    info "Activating profile: $PROFILE"

    # Deactivate all managed profiles first
    for CONN in "${CONNECTIONS[@]}"
    do
        nmcli connection down "$CONN" >/dev/null 2>&1 || true
    done

    # Activate the selected profile
    nmcli connection up "$PROFILE"

    sleep 2

    # Ensure only one default route remains
    if multiple_default_routes; then
        flush_default_routes
        nmcli connection up "$PROFILE"
        sleep 2
    fi

    # Determine the active device dynamically
    local DEVICE

    DEVICE=$(nmcli -t -f DEVICE connection show --active \
        | grep -v '^lo$' \
        | head -n1)

    [[ -n "$DEVICE" ]] || fatal "Unable to determine active interface."

    wait_for_ip "$DEVICE" \
        || fatal "Timed out waiting for DHCP."

    json_set ".mode=\"$TARGET\""
    json_set ".last_switch=\"$(timestamp)\""
    json_set ".default_interface=\"$DEVICE\""

    success "$PROFILE is active on $DEVICE."

}