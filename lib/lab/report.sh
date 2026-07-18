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

    json_get '.mode'

    echo

    echo "Interface"

    default_interface

    echo

    echo "Gateway"

    default_gateway

    echo

    echo "Hosts"

    inventory_list

}