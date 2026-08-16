#!/bin/bash

###############################################################################
# Network Provider
#
# NetworkManager implementation.
###############################################################################

switch_provider_activate() {

    local MODE="$1"
    local PROFILE

    case "$MODE" in
        update)  PROFILE="$PROFILE_NAT" ;;
        contain) PROFILE="$PROFILE_NATNET" ;;
        lab)     PROFILE="$PROFILE_LAB" ;;
        bridged) PROFILE="$PROFILE_BRIDGED" ;;
        *)
            log_error "Unknown network mode: $MODE"
            return 1
            ;;
    esac

    network_switch "$PROFILE"

}

switch_provider_reset() {

    nmcli networking off

    sleep 2

    nmcli networking on

}
