#!/bin/bash

###############################################################################
# REPORTING
###############################################################################

generate_report() {

    echo

    echo "=========================="

    echo "LAB REPORT"

    echo "=========================="

    echo

    echo "Mode"

    state_profile

    echo

    echo "Interface"

    network_default_interface

    echo

    echo "Gateway"

    network_default_gateway

    echo

    echo "Hosts"

    inventory_list

}
