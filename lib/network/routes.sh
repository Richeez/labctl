#!/bin/bash

###############################################################################
# Route Manager
###############################################################################

# Return current default interface
default_interface() {
    ip route \
        | awk '/^default/ {print $5; exit}'
}

# Return default gateway
default_gateway() {
    ip route \
        | awk '/^default/ {print $3; exit}'
}

# Print routing table
show_routes() {
    ip route
}

# Count default routes
default_route_count() {
    ip route \
        | grep '^default' \
        | wc -l
}

# True if multiple default routes exist
multiple_default_routes() {
    [[ "$(default_route_count)" -gt 1 ]]
}

# Remove all default routes
flush_default_routes() {
    while ip route | grep -q '^default'
    do
        ip route del default || break
    done
}

# Verify active default interface
verify_default_route() {

    local EXPECTED="$1"

    local CURRENT

    CURRENT=$(default_interface)

    [[ "$CURRENT" == "$EXPECTED" ]]

}