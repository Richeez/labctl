#!/bin/bash

###############################################################################
# Interface Manager
###############################################################################

# Return a list of all network interfaces except loopback
list_interfaces() {
    ip -o link show \
        | awk -F': ' '{print $2}' \
        | grep -v '^lo$'
}

# Check if an interface exists
interface_exists() {
    ip link show "$1" >/dev/null 2>&1
}

# Return true if interface is up
interface_up() {
    ip link show "$1" | grep -q "UP"
}

# Bring interface up
bring_interface_up() {
    local IFACE="$1"

    interface_exists "$IFACE" || fatal "Interface $IFACE not found."

    ip link set "$IFACE" up
}

# Bring interface down
bring_interface_down() {
    local IFACE="$1"

    interface_exists "$IFACE" || fatal "Interface $IFACE not found."

    ip link set "$IFACE" down
}

# Return IPv4 address
interface_ip() {
    local IFACE="$1"

    ip -4 addr show "$IFACE" \
        | awk '/inet / {print $2}' \
        | cut -d/ -f1
}

# Return CIDR
interface_cidr() {
    local IFACE="$1"

    ip -4 addr show "$IFACE" \
        | awk '/inet / {print $2}'
}

# Return MAC address
interface_mac() {
    local IFACE="$1"

    cat "/sys/class/net/$IFACE/address"
}

# Return interface state
interface_state() {
    nmcli -t \
        -f GENERAL.STATE \
        device show "$1" \
        | cut -d: -f2
}

# Return active NetworkManager connection
active_connection() {
    nmcli -t \
        -f GENERAL.CONNECTION \
        device show "$1" \
        | cut -d: -f2
}