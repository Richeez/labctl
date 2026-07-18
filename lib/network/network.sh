#!/usr/bin/env bash

###############################################################################
# Public Network API
###############################################################################

network_switch() {

    local PROFILE="$1"

    profile_deactivate_all

    profile_activate "$PROFILE"

}

network_update() {

    network_switch "$PROFILE_UPDATE"

}

network_lab() {

    network_switch "$PROFILE_LAB"

}

network_contain() {

    network_switch "$PROFILE_CONTAIN"

}

network_bridged() {

    network_switch "$PROFILE_BRIDGED"

}

network_default_interface() {

    ip route | awk '/default/ {print $5; exit}'

}

network_default_gateway() {

    ip route | awk '/default/ {print $3; exit}'

}