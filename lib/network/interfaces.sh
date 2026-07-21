#!/usr/bin/env bash

###############################################################################
# Interface API
#
# Responsible for:
#   - Listing interfaces
#   - Interface state
#   - MAC addresses
#   - IPv4 addresses
###############################################################################

###############################################################################
# List Interfaces
###############################################################################

network_interfaces() {

    ip -o link show \
        | awk -F': ' '{print $2}' \
        | grep -v '^lo$'

}

###############################################################################
# Interface Exists
###############################################################################

network_interface_exists() {

    local device="$1"

    ip link show "$device" >/dev/null 2>&1

}

###############################################################################
# Interface State
###############################################################################

network_interface_state() {

    local iface="$1"

    network_interface_exists "$iface" || return 1

    ip -br link show "$iface" | awk '{print $2}'

}


###############################################################################
# IPv4 Address
###############################################################################

network_interface_ip() {

    local device="$1"

    network_interface_exists "$device" || return 1

    ip -4 addr show "$device" \
        | awk '
            /inet / {
                print $2
                exit
            }
        '

}

###############################################################################
# MAC Address
###############################################################################

network_interface_mac() {

    local device="$1"

    network_interface_exists "$device" || return 1

    ip link show "$device" \
        | awk '
            /link\/ether/ {
                print $2
                exit
            }
        '

}