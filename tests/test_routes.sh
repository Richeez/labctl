#!/usr/bin/env bash

source "$(dirname "$0")/../lib/core/bootstrap.sh"

network_routes >/dev/null

state_connection >/dev/null

state_gateway >/dev/null