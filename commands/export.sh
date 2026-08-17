#!/usr/bin/env bash

run() {

    case "${1:-}" in
        -h|--help)
            cat <<EOF
Usage: labctl export [FILE]

Export the local inventory as CSV. Defaults to ~/lab_inventory.csv.
EOF
            return "$EXIT_SUCCESS"
            ;;
    esac

    export_csv "${1:-}"

}
