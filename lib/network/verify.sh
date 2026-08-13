#!/usr/bin/env bash

###############################################################################
# Network Verification
###############################################################################

verify_networkmanager() {

    if systemctl is-active --quiet NetworkManager; then
        log_success "NetworkManager is running."
        return 0
    fi

    log_error "NetworkManager is not running."
    return 1

}

###############################################################################
# Active Profile
###############################################################################

verify_active_profile() {

    local PROFILE
    local DEVICE

    PROFILE="$(state_profile)"

    if [[ -z "$PROFILE" ]]; then
        log_error "No active profile."
        return 1
    fi

    DEVICE="$(profile_active_device "$PROFILE")"

    if [[ -z "$DEVICE" ]]; then
        log_error "Profile '$PROFILE' has no active device."
        return 1
    fi

    log_success "Active profile: $PROFILE ($DEVICE)"
    return 0
}

###############################################################################
# Interface
###############################################################################

verify_interface() {

    local IFACE="${1:-}"

    if [[ -z "$IFACE" ]]; then
        log_error "No interface specified."
        return 1
    fi

    if ! network_interface_exists "$IFACE"; then
        log_error "Interface '$IFACE' does not exist."
        return 1
    fi

    if ! network_interface_connected "$IFACE"; then
        log_error "Interface '$IFACE' is not connected."
        return 1
    fi

    log_success "Interface '$IFACE' is connected."
    return 0

}

###############################################################################
# IPv4 Address
###############################################################################

verify_ip_address() {

    local PROFILE
    local DEVICE
    local IP

    PROFILE="$(state_profile)"

    [[ -n "$PROFILE" ]] || {
        log_error "No active profile."
        return 1
    }

    DEVICE="$(state_device "$PROFILE")"

    [[ -n "$DEVICE" ]] || {
        log_error "No associated interface."
        return 1
    }

    IP="$(state_ip "$DEVICE")"

    if [[ -n "$IP" ]]; then
        log_success "IPv4 address detected: $IP"
        return 0
    fi

    log_error "No IPv4 address assigned."
    return 1

}

###############################################################################
# Default Route
###############################################################################

verify_default_route() {

    if network_has_default_route; then
        log_success "Default route detected."
        return 0
    fi

    log_error "No default route found."
    return 1

}

###############################################################################
# Gateway
###############################################################################

verify_gateway() {

    local GATEWAY

    GATEWAY="$(state_gateway)"

    if [[ -n "$GATEWAY" ]]; then
        log_success "Gateway detected: $GATEWAY"
        return 0
    fi

    log_error "No gateway detected."
    return 1

}

###############################################################################
# DNS
###############################################################################

verify_dns() {

    local TIMEOUT="${PING_TIMEOUT:-2}"
    local TARGET="${DNS_TARGET:-1.1.1.1}"

    if ping \
        -c 1 \
        -W "$TIMEOUT" \
        "$TARGET" \
        >/dev/null 2>&1
    then
        log_success "DNS server reachable."
        return 0
    fi

    log_error "DNS server unreachable."
    return 1
}

###############################################################################
# Internet
###############################################################################

verify_internet() {

    local TIMEOUT="${PING_TIMEOUT:-2}"
    local TARGET="${INTERNET_TARGET:-8.8.8.8}"

    if ping \
        -c 1 \
        -W "$TIMEOUT" \
        "$TARGET" \
        >/dev/null 2>&1
    then
        log_success "Internet connectivity verified."
        return 0
    fi

    log_error "No Internet connectivity."
    return 1
}

###############################################################################
# Full Verification
###############################################################################

verify_all() {

    local FAILED=0
    local PROFILE
    local DEVICE

    PROFILE="$(state_profile)"

    if [[ -n "$PROFILE" ]]; then
        DEVICE="$(profile_active_device "$PROFILE")"
    fi

    verify_networkmanager || ((++FAILED))
    verify_active_profile || ((++FAILED))

    if [[ -n "$DEVICE" ]]; then
        verify_interface "$DEVICE" || ((++FAILED))
    else
        log_error "No active device."
        ((++FAILED))
    fi

    verify_ip_address || ((++FAILED))
    verify_default_route || ((++FAILED))
    verify_gateway || ((++FAILED))

    echo

    if ((FAILED == 0)); then
        log_success "All health checks passed."
        return 0
    fi

    log_error "$FAILED health check(s) failed."
    return 1
}

verify_profile() {

    local PROFILE="${1:-}"

    if [[ -z "$PROFILE" ]]; then
        log_error "verify_profile(): profile not specified."
        return 1
    fi
    local DEVICE

    DEVICE="$(profile_active_device "$PROFILE")"

    [[ -n "$DEVICE" ]] || {
        log_error "No active device for '$PROFILE'."
        return 1
    }

    case "$PROFILE" in

        "$PROFILE_NAT")
            verify_nat "$DEVICE"
            ;;

        "$PROFILE_NATNET")
            verify_natnet "$DEVICE"
            ;;

        "$PROFILE_BRIDGED")
            verify_bridged "$DEVICE"
            ;;

        "$PROFILE_LAB")
            verify_lab "$DEVICE"
            ;;

        *)
            log_error "Unknown profile: $PROFILE"
            return 1
            ;;

    esac
}

verify_lab() {

    local DEVICE="$1"

    verify_interface "$DEVICE" &&
    verify_ip_address

}

verify_bridged() {

    local DEVICE="$1"

    verify_interface "$DEVICE" &&
    verify_ip_address &&
    verify_default_route &&
    verify_gateway

}

verify_natnet() {

    local DEVICE="$1"

    verify_interface "$DEVICE" &&
    verify_ip_address &&
    verify_default_route &&
    verify_gateway

}

verify_nat() {

    local DEVICE="$1"

    verify_interface "$DEVICE" &&
    verify_ip_address &&
    verify_default_route &&
    verify_gateway &&
    verify_dns &&
    verify_internet

}