#!/usr/bin/env bash

source "$(dirname "$0")/../lib/core/bootstrap.sh"

profile_exists "$PROFILE_NAT"
profile_exists "$PROFILE_LAB"
profile_exists "$PROFILE_BRIDGED"
profile_exists "$PROFILE_NATNET"