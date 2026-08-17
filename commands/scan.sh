#!/usr/bin/env bash

run() {

    case "${1:-}" in
        -h|--help|"")
            cat <<EOF
Usage: sudo labctl scan <target>

Run service and operating-system detection against a single target.
EOF
            return "$EXIT_SUCCESS"
            ;;
    esac

    require_root || return $?

    scan_services "$1"

}
