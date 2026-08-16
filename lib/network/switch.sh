#!/bin/bash

###############################################################################
# Network Switching Engine
###############################################################################

activate_connection() {

    local TARGET="$1"
    local PROFILE

    case "$TARGET" in
        update)  PROFILE="$PROFILE_NAT" ;;
        contain) PROFILE="$PROFILE_NATNET" ;;
        lab)     PROFILE="$PROFILE_LAB" ;;
        bridged) PROFILE="$PROFILE_BRIDGED" ;;
        *)
            log_error "Unknown network mode: $TARGET"
            return 1
            ;;
    esac

    # Legacy callers must use the same exclusive, transactional switch path.
    network_switch "$PROFILE"

}
