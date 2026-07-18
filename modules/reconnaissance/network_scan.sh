#!/bin/bash

run_network_scan() {

    local IFACE

    IFACE=$(default_route)

    [[ -z "$IFACE" ]] && {

        error "No active interface."

        return 1

    }

    local CIDR

    CIDR=$(ip -4 addr show "$IFACE" \
        | awk '/inet /{print $2}')

    info "Scanning $CIDR"

    nmap -sn "$CIDR"

}