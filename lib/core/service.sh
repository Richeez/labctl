#!/bin/bash

###############################################################
# Service API
###############################################################

service_network_switch(){

    switch_network "$@"

}

service_verify(){

    verify_default_route "$@"

}

service_discover(){

    discover_hosts "$@"

}

service_report(){

    generate_report "$@"

}

service_inventory(){

    list_hosts

}

service_firewall(){

    firewall "$@"

}