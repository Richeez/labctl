#!/bin/bash

###############################################################
# Dedicated Firewall Chain
###############################################################

CHAIN="LABCTL"

create_chain() {

iptables -N "$CHAIN" 2>/dev/null || true

iptables -C INPUT -j "$CHAIN" 2>/dev/null \
|| iptables -I INPUT 1 -j "$CHAIN"

}

flush_chain() {

iptables -F "$CHAIN"

}

allow_lab() {

local SUBNET="$1"

iptables -A "$CHAIN" \
-s "$SUBNET" \
-j ACCEPT

}

block_all() {

iptables -A "$CHAIN" \
-j DROP

}