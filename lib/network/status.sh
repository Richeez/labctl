#!/usr/bin/env bash

###############################################################################
# Network Status Service
###############################################################################

###############################################################################
# Print Interface Table
###############################################################################

network_status_table() {

    printf "%-10s %-10s %-13s %-18s %-16s %-18s %-8s\n" \
        "PROFILE" \
        "DEVICE" \
        "LINK" \
        "IP ADDRESS" \
        "GATEWAY" \
        "MAC ADDRESS" \
        "ACTIVE"

    printf "%-10s %-10s %-13s %-18s %-16s %-18s %-8s\n" \
        "--------" \
        "------" \
        "------------" \
        "-----------------" \
        "---------------" \
        "-----------------" \
        "------"

    local PROFILE
    local DEVICE
    local LINK
    local IP
    local GATEWAY
    local MAC
    local ACTIVE

    local DEFAULT_IFACE
    local DEFAULT_GATEWAY

    DEFAULT_IFACE="$(network_default_interface)"
    DEFAULT_GATEWAY="$(state_gateway)"

    while IFS= read -r PROFILE
    do

        DEVICE="$(state_device "$PROFILE")"

        #
        # Profile not currently attached to a device
        #
        if [[ -z "$DEVICE" ]]; then

            DEVICE="-"
            LINK="-"
            IP="-"
            GATEWAY="-"
            MAC="-"

        else

            LINK="$(state_connection "$DEVICE")"
            IP="$(state_ip "$DEVICE")"
            MAC="$(state_mac "$DEVICE")"

            if [[ "$DEVICE" == "$DEFAULT_IFACE" ]]; then
                GATEWAY="$DEFAULT_GATEWAY"
            else
                GATEWAY="-"
            fi

        fi

        if profile_is_active "$PROFILE"; then
            ACTIVE="YES"
        else
            ACTIVE="NO"
        fi

        printf "%-10s %-10s %-13s %-18s %-16s %-18s %-8s\n" \
            "$PROFILE" \
            "$DEVICE" \
            "$LINK" \
            "$IP" \
            "$GATEWAY" \
            "$MAC" \
            "$ACTIVE"

    done < <(profile_list)

}



network_status_summary() {

    local PROFILE
    local DEVICE

    PROFILE="$(state_profile)"
    DEVICE="$(state_device "$PROFILE")"

    echo

    log_info "Current Profile   : ${PROFILE:--}"
    log_info "Default Interface : ${DEVICE:--}"
    log_info "IPv4 Address      : $(value_or_dash "$(state_ip "$DEVICE")")"
    log_info "Default Gateway   : $(value_or_dash "$(state_gateway)")"

}

network_status_routes() {

    echo

    log_banner "ROUTING TABLE"

    network_routes

}


network_status_health() {

    local PROFILE

    PROFILE="$(state_profile)"

    echo
    log_banner "HEALTH CHECKS"

    if [[ -z "$PROFILE" ]]; then
        log_error "No active profile."
        return 1
    fi

    verify_profile "$PROFILE"

}


network_status() {

    ui_start "LABCTL STATUS"

    network_status_table

    network_status_summary

    network_status_routes

    network_status_health

    ui_finish

}