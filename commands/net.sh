#!/usr/bin/env bash

# Short network-mode alias.  With no argument, return to Internet/NAT mode.
source "$LABCTL_HOME/commands/network.sh"

run() {

    network_mode_run "${1:-internet}"

}
