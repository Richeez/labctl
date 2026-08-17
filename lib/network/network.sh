#!/usr/bin/env bash

###############################################################################
# Network Service
###############################################################################

network_switch() {

    local PROFILE="$1"

    profile_exists "$PROFILE" || {

        log_error "Unknown profile '$PROFILE'."

        return 1

    }

    profile_validate "$PROFILE" || {

        log_error "Profile '$PROFILE' is misconfigured."

        echo

        log_info "Run:"

        echo "    sudo labctl doctor --repair"

        return 1

    }

    log_info "Switching network profile..."

    profile_activate_only "$PROFILE"

}

# network_switch() {

#     local PROFILE="$1"

#     #
#     # Verify profile exists
#     #
#     if ! profile_exists "$PROFILE"; then
#         log_error "Profile '$PROFILE' does not exist."
#         return 1
#     fi

#     #
#     # Verify profile configuration
#     #
#     if ! profile_validate "$PROFILE"; then
#         log_error "Profile '$PROFILE' is misconfigured."
#         echo
#         log_info "Run:"
#         echo "    sudo labctl doctor --repair"
#         return 1
#     fi

#     log_info "Switching network profile..."

#     profile_activate_only "$PROFILE"

# }

network_internet() {

    network_switch "$PROFILE_NAT"

}

# Compatibility for internal callers.  The CLI name is `network internet` so
# it cannot be confused with the application update command.
network_update() {

    network_internet

}

network_contain() {

    network_switch "$PROFILE_NATNET"

}

network_lab() {

    network_switch "$PROFILE_LAB"

}

network_bridged() {

    network_switch "$PROFILE_BRIDGED"

}
