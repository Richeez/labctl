#!/bin/bash

###############################################################################
# CSV EXPORT
###############################################################################

export_csv() {

    local FILE="${1:-$HOME/lab_inventory.csv}"
    local INVENTORY
    INVENTORY="$(inventory_file)"

    init_inventory || return 1

    echo "IP,HOSTNAME,OS" > "$FILE"

    jq -r '

        .hosts[]

        | "\(.ip),\(.hostname),\(.os)"

    ' "$INVENTORY" >> "$FILE"

    log_success "Inventory exported to $FILE"

}
