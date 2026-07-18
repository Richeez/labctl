#!/bin/bash

###############################################################################
# VM Command
###############################################################################

run() {

    case "$1" in

        list)

            virtualbox_service_list

            ;;

        running)

            virtualbox_service_running

            ;;

        info)

            shift

            virtualbox_service_info "$1"

            ;;

        start)

            shift

            require_root

            virtualbox_service_start "$1"

            ;;

        stop)

            shift

            require_root

            virtualbox_service_stop "$1"

            ;;

        *)

cat <<EOF

Usage

labctl vm list

labctl vm running

labctl vm info <vm>

sudo labctl vm start <vm>

sudo labctl vm stop <vm>

EOF

        ;;

    esac

}