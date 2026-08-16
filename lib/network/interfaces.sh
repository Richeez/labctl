#!/usr/bin/env bash

###############################################################################
# Interface API
#
# Responsible for:
#   - Listing interfaces
#   - Interface state
#   - Connection status
#   - IPv4 addresses
#   - MAC addresses
###############################################################################

###############################################################################
# List Interfaces
###############################################################################

network_interfaces() {

    nmcli -t -f DEVICE device \
        | grep -v '^lo$'

}

###############################################################################
# Interface Exists
###############################################################################

network_interface_exists() {

    local IFACE="$1"

    ip link show "$IFACE" >/dev/null 2>&1

}

###############################################################################
# Interface State
#
# Returns:
#   connected
#   disconnected
#   connecting
#   unavailable
#   unmanaged
#   unknown
###############################################################################

network_interface_state() {

    local IFACE="$1"
    local STATE

    network_interface_exists "$IFACE" || {
        echo "-"
        return 1
    }

    STATE="$(
        nmcli -t -f DEVICE,STATE device \
            | awk -F: -v iface="$IFACE" '
                $1 == iface {
                    print $2
                    exit
                }
            '
    )"

    case "$STATE" in
        connected)
            echo "connected"
            ;;
        connecting)
            echo "connecting"
            ;;
        disconnected|unavailable|unmanaged|failed)
            echo "disconnected"
            ;;
        *)
            echo "-"
            ;;
    esac

}

# network_interface_state() {

#     local IFACE="$1"

#     network_interface_exists "$IFACE" || {
#         echo "unknown"
#         return 1
#     }

#     nmcli -t -f DEVICE,STATE device \
#         | awk -F: -v iface="$IFACE" '
#             $1 == iface {
#                 print $2
#                 exit
#             }
#         '

# }

###############################################################################
# Interface Connected
###############################################################################

network_interface_connected() {

    local IFACE="$1"

    [[ "$(network_interface_state "$IFACE")" == "connected" ]]

}

###############################################################################
# IPv4 Address
###############################################################################

network_interface_ip() {

    local IFACE="$1"

    network_interface_exists "$IFACE" || return 1

    ip -4 -o addr show dev "$IFACE" \
        | awk '{print $4; exit}'

}

###############################################################################
# Has IPv4 Address
###############################################################################

network_interface_has_ip() {

    local IFACE="$1"

    [[ -n "$(network_interface_ip "$IFACE")" ]]

}

###############################################################################
# MAC Address
###############################################################################

network_interface_mac() {

    local IFACE="$1"

    network_interface_exists "$IFACE" || return 1

    ip link show "$IFACE" \
        | awk '
            /link\/ether/ {
                print $2
                exit
            }
        '

}


# Return CIDR
interface_cidr() {
    local IFACE="$1"

    ip -4 addr show "$IFACE" \
        | awk '/inet / {print $2}'
}
