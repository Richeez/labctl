#!/bin/bash

###############################################################################
# HELP
###############################################################################

run() {
profile_list

profile_active

profile_device NAT

profile_is_active NAT && echo "YES"

network_interfaces

network_interface_ip eth0

network_interface_mac eth0

network_interface_state eth0

cat <<EOF

LABCTL v$VERSION

Usage:

sudo labctl update
    Enable Internet access through NAT.

sudo labctl lab
    Switch to Host-only laboratory.

sudo labctl contain
    Switch to NAT Network containment mode.

sudo labctl bridged
    Connect to the physical LAN.

labctl status
    Show current network status.

labctl version
    Show version information.

labctl help
    Display this help message.

EOF

}