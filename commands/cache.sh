#!/usr/bin/env bash

###############################################################################
# LABCTL Cache Command
###############################################################################

run() {

    case "${1:-}" in

        status)

            cache_status
            ;;


        clear)

            cache_clear
            ;;


        rebuild)

            cache_rebuild
            ;;


        -h|--help|"")
            cat <<EOF

Usage:
  labctl cache status
  labctl cache clear
  labctl cache rebuild

EOF
            ;;


        *)

            log_error "Unknown cache command: $1"
            return "$EXIT_INVALID_ARGUMENT"
            ;;

    esac

}