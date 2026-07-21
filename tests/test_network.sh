#!/usr/bin/env bash

source "$(dirname "$0")/../lib/core/bootstrap.sh"

network_current_profile >/dev/null

network_status_summary >/dev/null