#!/bin/bash

###############################################################################
# HOST DISCOVERY
###############################################################################



discover_network(){

local IFACE

IFACE=$(default_interface)

local SUBNET

SUBNET=$(interface_cidr "$IFACE")

SCAN_DIR="/var/lib/labctl/scans"

mkdir -p "$SCAN_DIR"

local XML="$SCAN_DIR/discovery.xml"

nmap \
    -sn \
    -oX "$XML" \
    "$SUBNET"

parse_discovery "$XML"

}
# discover_network() {

#     local DEV

#     DEV=$(default_interface)

#     [[ -z "$DEV" ]] && fatal "No active interface."

#     local SUBNET

#     SUBNET=$(interface_cidr "$DEV")

#     info "Scanning $SUBNET..."

#     sudo nmap \
#         -sn \
#         "$SUBNET"

# }