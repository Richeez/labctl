#!/usr/bin/env bash

###############################################################################
# Network Verification
###############################################################################



verify_default_route() {

    if network_has_default_route; then
        log_success "Default route detected."
        return 0
    fi

    log_error "No default route found."
    return 1

}

verify_gateway() {

    local gateway

    gateway="$(network_default_gateway)"

    if [[ -n "$gateway" ]]; then
        log_success "Gateway detected: $gateway"
        return 0
    fi

    log_error "No gateway detected."
    return 1

}

verify_interface() {

    local IFACE="$1"

    interface_exists "$IFACE" || return 1

    interface_up "$IFACE"

}

verify_ip_address() {

    local profile
    local device
    local ip

    profile="$(network_current_profile)"
    device="$(profile_device "$profile")"
    ip="$(network_interface_ip "$device")"

    if [[ -n "$ip" ]]; then
        log_success "IPv4 address detected: $ip"
        return 0
    fi

    log_error "No IPv4 address assigned."
    return 1

}

verify_gateway() {

    [[ -n "$(network_default_gateway)" ]]

}

verify_dns() {

    ping \
        -c1 \
        -W"$PING_TIMEOUT" \
        "$DNS_TARGET" \
        >/dev/null 2>&1

}

verify_internet() {

    ping \
        -c1 \
        -W"$PING_TIMEOUT" \
        "$PING_TARGET" \
        >/dev/null 2>&1

}

verify_network() {

    local IFACE="$1"

    verify_interface "$IFACE" \
        || fatal "Interface verification failed."

    verify_ip "$IFACE" \
        || fatal "No IPv4 address."

    verify_gateway \
        || fatal "Gateway missing."

}

verify_active_profile() {

    local profile
    local device

    profile="$(network_current_profile)"

    if [[ -z "$profile" ]]; then
        log_error "No active profile."
        return 1
    fi

    device="$(profile_device "$profile")"

    if [[ -z "$device" ]]; then
        log_error "Profile '$profile' has no associated device."
        return 1
    fi

    log_success "Active profile: $profile ($device)"
    return 0

}

verify_networkmanager() {

    if systemctl is-active --quiet NetworkManager; then
        log_success "NetworkManager is running."
        return 0
    fi

    log_error "NetworkManager is not running."
    return 1

}

verify_all() {

    local failed=0

    verify_networkmanager || ((failed++))
    verify_active_profile || ((failed++))
    verify_default_route || ((failed++))
    verify_gateway || ((failed++))
    verify_ip_address || ((failed++))

    echo

    if (( failed == 0 )); then
        log_success "All health checks passed."
        return 0
    fi

    log_error "$failed health check(s) failed."
    return 1

}