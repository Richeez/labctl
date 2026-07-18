#!/bin/bash

###############################################################################
# Inventory Engine
###############################################################################

INVENTORY="/var/lib/labctl/inventory.json"

init_inventory() {

    mkdir -p /var/lib/labctl

    [[ -f "$INVENTORY" ]] && return

cat > "$INVENTORY" <<EOF
{
    "hosts":[]
}
EOF

}

inventory_exists() {

    local IP="$1"

    jq -e \
        --arg ip "$IP" \
        '.hosts[] | select(.ip==$ip)' \
        "$INVENTORY" >/dev/null

}

inventory_add() {

    local IP="$1"
    local MAC="$2"
    local HOST="$3"
    local OS="$4"

    inventory_exists "$IP" && {

        inventory_update "$@"

        return

    }

    local TMP

    TMP=$(mktemp)

    jq \
        --arg ip "$IP" \
        --arg mac "$MAC" \
        --arg host "$HOST" \
        --arg os "$OS" \
        --arg time "$(date --iso-8601=seconds)" \
        '.hosts += [{
            ip:$ip,
            mac:$mac,
            hostname:$host,
            os:$os,
            last_seen:$time
        }]' \
        "$INVENTORY" > "$TMP"

    mv "$TMP" "$INVENTORY"

}

inventory_update() {

    local IP="$1"
    local MAC="$2"
    local HOST="$3"
    local OS="$4"

    local TMP

    TMP=$(mktemp)

    jq \
        --arg ip "$IP" \
        --arg mac "$MAC" \
        --arg host "$HOST" \
        --arg os "$OS" \
        --arg time "$(date --iso-8601=seconds)" '
.hosts |= map(
if .ip==$ip then
.mac=$mac |
.hostname=$host |
.os=$os |
.last_seen=$time
else .
end
)
' "$INVENTORY" > "$TMP"

    mv "$TMP" "$INVENTORY"

}