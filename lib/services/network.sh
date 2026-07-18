#!/bin/bash

###############################################################################
# Network Service
#
# High-level networking API.
# Commands use this layer instead of calling providers directly.
###############################################################################

network_service_switch() {

    local MODE="$1"

    switch_provider_activate "$MODE"

}

network_service_verify() {

    local DEVICE

    DEVICE=$(default_interface)

    verify_network "$DEVICE"

}

network_service_status() {

    dashboard

}

network_service_reset() {

    switch_provider_reset

}

network_service_default_interface() {

    default_interface

}