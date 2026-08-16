#!/usr/bin/env bash

###############################################################################
# Routing API
#
# Responsible for:
#   - Default gateway
#   - Default interface
#   - Routing table
#   - Route management
###############################################################################

###############################################################################
# Routing Table
###############################################################################

network_routes() {

    ip route

}

###############################################################################
# Default Gateway
###############################################################################

network_default_gateway() {

    ip route \
        | awk '
            /^default/ {
                print $3
                exit
            }
        '

}

###############################################################################
# Default Interface
###############################################################################

network_default_interface() {

    ip route \
        | awk '
            /^default/ {
                print $5
                exit
            }
        '

}

###############################################################################
# Has Default Route
###############################################################################

network_has_default_route() {

    ip route | grep -q '^default'

}

###############################################################################
# Route Count
###############################################################################

network_route_count() {

    ip route | wc -l

}

###############################################################################
# Flush Default Routes
###############################################################################

network_flush_default_routes() {

    log_info "Removing existing default routes..."

    while network_has_default_route; do

        local gateway
        local device

        gateway=$(network_default_gateway)
        device=$(network_default_interface)

        if ! ip route del default via "$gateway" dev "$device" 2>/dev/null; then
            break
        fi

    done

    log_success "Default routes cleared."

}

###############################################################################
# Default Route
###############################################################################

network_default_route() {

    ip route show default 2>/dev/null
}