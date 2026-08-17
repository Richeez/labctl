#!/bin/bash

###############################################################################
# VM Command
###############################################################################

run() {

    local ACTION="${1:-}"
    shift || true

    case "$ACTION" in

        list)

            virtualbox_service_list

            ;;

        running)

            virtualbox_service_running

            ;;

        info)
            [[ -n "${1:-}" ]] || { log_error "Specify a VM name."; return "$EXIT_INVALID_ARGUMENT"; }
            virtualbox_service_info "$1"

            ;;

        start)
            [[ -n "${1:-}" ]] || { log_error "Specify a VM name."; return "$EXIT_INVALID_ARGUMENT"; }
            require_root || return $?
            virtualbox_service_start "$1"

            ;;

        stop)
            [[ -n "${1:-}" ]] || { log_error "Specify a VM name."; return "$EXIT_INVALID_ARGUMENT"; }
            require_root || return $?
            virtualbox_service_stop "$1"

            ;;

        -h|--help|"")

cat <<EOF

Usage

labctl vm list

labctl vm running

labctl vm info <vm>

sudo labctl vm start <vm>

sudo labctl vm stop <vm>

EOF
            ;;
        *)
            log_error "Unknown VM command: $ACTION"
            return "$EXIT_INVALID_ARGUMENT"
            ;;

    esac

}
