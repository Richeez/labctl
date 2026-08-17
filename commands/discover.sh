#!/usr/bin/env bash

run() {

    case "${1:-}" in
        -h|--help)
            cat <<EOF
Usage: sudo labctl discover

Discover live hosts on the subnet of the default interface and update the
local inventory.
EOF
            return "$EXIT_SUCCESS"
            ;;
        "")
            ;;
        *)
            log_error "Unknown discover option: $1"
            return "$EXIT_INVALID_ARGUMENT"
            ;;
    esac

    require_root || return $?

    discover_network

}
