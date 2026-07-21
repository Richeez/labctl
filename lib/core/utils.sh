#!/bin/bash

###############################################################################
# Utilities
###############################################################################

require_root() {

    [[ "$EUID" -eq 0 ]] || log_error "Please run with sudo."

}

command_exists() {

    command -v "$1" >/dev/null 2>&1

}

require_command() {

    command_exists "$1" || log_error "$1 not installed."

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


value_or_dash() {

    [[ -n "$1" ]] && printf "%s" "$1" || printf "-"
}