#!/usr/bin/env bash

run() {

    case "${1:-}" in
        "") generate_report ;;
        -h|--help)
            printf '%s\n' 'Usage: labctl report'
            ;;
        *)
            log_error "Unknown report option: $1"
            return "$EXIT_INVALID_ARGUMENT"
            ;;
    esac

}
