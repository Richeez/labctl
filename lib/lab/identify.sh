#!/bin/bash

###############################################################################
# VM IDENTIFICATION
###############################################################################

identify_vendor() {

    local MAC="$1"

    case "${MAC:0:8}" in

        08:00:27)

            echo "VirtualBox"

            ;;

        00:0C:29)

            echo "VMware"

            ;;

        *)

            echo "Unknown"

            ;;

    esac

}