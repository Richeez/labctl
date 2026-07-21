#!/usr/bin/env bash

source "$(dirname "$0")/../lib/core/bootstrap.sh"

while IFS= read -r iface; do

    network_interface_exists "$iface"

done < <(network_interfaces)