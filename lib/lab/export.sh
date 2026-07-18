#!/bin/bash

###############################################################################
# CSV EXPORT
###############################################################################

export_csv() {

    local FILE="$HOME/lab_inventory.csv"

    echo "IP,HOSTNAME,OS" > "$FILE"

    jq -r '

        .hosts[]

        | "\(.ip),\(.hostname),\(.os)"

    ' "$INVENTORY" >> "$FILE"

    success "Inventory exported to $FILE"

}