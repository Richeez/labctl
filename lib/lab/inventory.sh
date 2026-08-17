#!/bin/bash

###############################################################################
# Inventory Engine
###############################################################################

inventory_file() {
    printf '%s/inventory.json\n' "$STATE_DIR"
}

init_inventory() {

    local INVENTORY
    INVENTORY="$(inventory_file)"

    mkdir -p "$STATE_DIR" || return 1

    [[ -f "$INVENTORY" ]] && return

cat > "$INVENTORY" <<EOF
{
    "hosts":[]
}
EOF

}

inventory_exists() {

    local IP="$1"
    local INVENTORY
    INVENTORY="$(inventory_file)"

    init_inventory || return 1

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

    local INVENTORY TMP
    INVENTORY="$(inventory_file)"

    init_inventory || return 1

    TMP=$(mktemp "$STATE_DIR/inventory.XXXXXX") || return 1

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

    local INVENTORY TMP
    INVENTORY="$(inventory_file)"

    init_inventory || return 1

    TMP=$(mktemp "$STATE_DIR/inventory.XXXXXX") || return 1

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

inventory_list() {

    local INVENTORY
    INVENTORY="$(inventory_file)"
    init_inventory || return 1

    jq -r '.hosts[] | [.ip, .hostname, .mac, .os, .last_seen] | @tsv' "$INVENTORY" |
        awk 'BEGIN { print "IP\tHOSTNAME\tMAC\tOS\tLAST SEEN" } { print }'

}
