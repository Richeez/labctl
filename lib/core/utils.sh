#!/bin/bash

###############################################################################
# Utilities
###############################################################################

require_root() {

    [[ "$EUID" -eq 0 ]] || fatal "Please run with sudo."

}

command_exists() {

    command -v "$1" >/dev/null 2>&1

}

require_command() {

    command_exists "$1" || fatal "$1 not installed."

}

validate_dependencies() {

    local REQUIRED=(

        jq

        nmcli

        ip

        ping

        awk

        grep

        sed

        nmap

    )

    for CMD in "${REQUIRED[@]}"

    do

        require_command "$CMD"

    done

}


timestamp() {

    date '+%F %T'

}