#!/usr/bin/env bash

source "$(dirname "$0")/../lib/core/bootstrap.sh"

[[ -n "$LABCTL_HOME" ]]
[[ -n "$LABCTL_NAME" ]]
[[ -n "$LABCTL_VERSION" ]]
[[ -n "$PROFILE_NAT" ]]
[[ -n "$PROFILE_LAB" ]]
[[ -n "$PROFILE_BRIDGED" ]]
[[ -n "$PROFILE_NATNET" ]]