#!/usr/bin/env bash

source "$(dirname "$0")/../lib/core/bootstrap.sh"

state_profile >/dev/null

network_status_summary >/dev/null