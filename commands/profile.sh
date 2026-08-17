#!/usr/bin/env bash

run() {

    case "${1:-}" in
        kioptrix)
            require_root || return $?
            profile_kioptrix
            ;;
        metasploitable)
            require_root || return $?
            profile_metasploitable
            ;;
        -h|--help|"")
            cat <<EOF
Usage: sudo labctl profile <name>

Profiles:
  kioptrix
  metasploitable
EOF
            ;;
        *)
            log_error "Unknown lab profile: $1"
            return "$EXIT_INVALID_ARGUMENT"
            ;;
    esac

}
