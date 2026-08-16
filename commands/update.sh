#!/usr/bin/env bash

# `update` is reserved for updating labctl itself.  Network modes are exposed
# under `labctl network` to prevent the two operations from colliding.
source "$LABCTL_HOME/commands/upgrade.sh"
