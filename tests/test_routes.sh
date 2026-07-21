#!/usr/bin/env bash

source "$(dirname "$0")/../lib/core/bootstrap.sh"

network_routes >/dev/null

network_default_interface >/dev/null

network_default_gateway >/dev/null