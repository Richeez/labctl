#!/bin/bash

###############################################################################
# HELP
###############################################################################

run() {

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