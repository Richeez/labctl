#!/usr/bin/env bash

###############################################################################
# Configuration Loader
###############################################################################


CONFIG_FILE="$LABCTL_HOME/config/default.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Configuration file not found:"
    echo "$CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

# CONFIG_FILE="/etc/labctl/config.json"

# if [[ ! -f "$CONFIG_FILE" ]]; then
#     echo "Missing configuration."

#     exit 1
# fi

# VERSION=$(jq -r '.version' "$CONFIG_FILE")

# LOG_LEVEL=$(jq -r '.logging.level' "$CONFIG_FILE")

# LOG_FILE=$(jq -r '.logging.file' "$CONFIG_FILE")

# NAT_DEV=$(jq -r '.interfaces.nat' "$CONFIG_FILE")

# HOSTONLY_DEV=$(jq -r '.interfaces.hostonly' "$CONFIG_FILE")

# BRIDGED_DEV=$(jq -r '.interfaces.bridged' "$CONFIG_FILE")

# CONTAIN_DEV=$(jq -r '.interfaces.contain' "$CONFIG_FILE")

# DHCP_TIMEOUT=$(jq -r '.timeouts.dhcp' "$CONFIG_FILE")

# PING_TIMEOUT=$(jq -r '.timeouts.ping' "$CONFIG_FILE")

# DNS_TARGET=$(jq -r '.network.dns' "$CONFIG_FILE")

# PING_TARGET=$(jq -r '.network.internet_check' "$CONFIG_FILE")

# UPDATE_CONN=$(jq -r '.connections.update' "$CONFIG_FILE")

# LAB_CONN=$(jq -r '.connections.lab' "$CONFIG_FILE")

# BRIDGED_CONN=$(jq -r '.connections.bridged' "$CONFIG_FILE")

# CONTAIN_CONN=$(jq -r '.connections.contain' "$CONFIG_FILE")