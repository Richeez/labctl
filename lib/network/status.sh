#!/usr/bin/env bash

###############################################################################
# Network Status Service
###############################################################################

###############################################################################
# Print Interface Table
###############################################################################

network_status_table() {

    printf "%-10s %-10s %-12s %-18s %-16s %-18s %-10s\n" \
        "PROFILE" \
        "DEVICE" \
        "LINK" \
        "IP ADDRESS" \
        "GATEWAY" \
        "MAC ADDRESS" \
        "ACTIVE"

    printf "%-10s %-10s %-12s %-18s %-16s %-18s %-10s\n" \
        "--------" \
        "------" \
        "----------" \
        "-----------------" \
        "---------------" \
        "-----------------" \
        "------"

    local profile
    local device
    local gateway
    local active

    local default_interface
local default_gateway

default_interface="$(network_default_interface)"
default_gateway="$(network_default_gateway)"

while IFS= read -r profile; do

    device="$(profile_device "$profile")"

    gateway="-"

    if [[ "$device" == "$default_interface" ]]; then
        gateway="$default_gateway"
    fi

    if profile_is_active "$profile"; then
        active="YES"
    else
        active="NO"
    fi

    printf "%-10s %-10s %-12s %-18s %-16s %-18s %-10s\n" \
        "$profile" \
        "$(value_or_dash "$device")" \
        "$(value_or_dash "$(network_interface_state "$device")")" \
        "$(value_or_dash "$(network_interface_ip "$device")")" \
        "$(value_or_dash "$gateway")" \
        "$(value_or_dash "$(network_interface_mac "$device")")" \
        "$active"

done < <(profile_list)

}


network_status_summary() {

    echo

    log_info "Current Profile : $(value_or_dash "$(network_current_profile)")"

    log_info "Default Interface : $(value_or_dash "$(network_default_interface)")"

    log_info "Default Gateway   : $(value_or_dash "$(network_default_gateway)")"

}

network_status_routes() {

    echo

    log_banner "ROUTING TABLE"

    network_routes

}


network_status_health() {

    echo

    log_banner "HEALTH CHECKS"

    verify_all

}


network_status() {

    log_banner "LABCTL STATUS"

    network_status_table

    network_status_summary

    network_status_routes

    network_status_health

}