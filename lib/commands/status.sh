#!/bin/bash

###############################################################################
# STATUS
###############################################################################


run() {

    echo
    echo "========== LABCTL STATUS =========="
    echo

    echo "Active connections:"
    nmcli -t -f NAME,DEVICE connection show --active

    echo
    echo "Default interface : $(network_default_interface)"
    echo "Default gateway   : $(network_default_gateway)"

    echo
    echo "IP Addresses:"
    ip -brief addr

    echo
}
# run() {

#  dashboard

# }

