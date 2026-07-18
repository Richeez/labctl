#!/bin/bash

###############################################################################
# Network Verification
###############################################################################

verify_interface() {

    local IFACE="$1"

    interface_exists "$IFACE" || return 1

    interface_up "$IFACE"

}

verify_ip() {

    local IFACE="$1"

    [[ -n "$(interface_ip "$IFACE")" ]]

}

verify_gateway() {

    [[ -n "$(default_gateway)" ]]

}

verify_dns() {

    ping \
        -c1 \
        -W"$PING_TIMEOUT" \
        "$DNS_TARGET" \
        >/dev/null 2>&1

}

verify_internet() {

    ping \
        -c1 \
        -W"$PING_TIMEOUT" \
        "$PING_TARGET" \
        >/dev/null 2>&1

}

verify_network() {

    local IFACE="$1"

    verify_interface "$IFACE" \
        || fatal "Interface verification failed."

    verify_ip "$IFACE" \
        || fatal "No IPv4 address."

    verify_gateway \
        || fatal "Gateway missing."

}