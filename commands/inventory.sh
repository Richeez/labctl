#!/usr/bin/env bash

run() {

    case "${1:-}" in
        ""|list)
            inventory_list
            ;;
        -h|--help)
            cat <<EOF
Usage: labctl inventory [list]

Show hosts stored by labctl discover.
EOF
            ;;
        *)
            log_error "Unknown inventory command: $1"
            return "$EXIT_INVALID_ARGUMENT"
            ;;
    esac

}
