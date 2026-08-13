# #!/bin/bash

# ###############################################################################
# # JSON State Engine
# ###############################################################################

# STATE_DIR="/var/lib/labctl"

# STATE_FILE="$STATE_DIR/state.json"

# init_state() {

#     mkdir -p "$STATE_DIR"

#     if [[ ! -f "$STATE_FILE" ]]; then

# cat > "$STATE_FILE" <<EOF
# {
#     "mode":"",
#     "last_switch":"",
#     "default_interface":"",
#     "inventory":[]
# }
# EOF

#     fi

# }

# json_get() {

#     jq -r "$1" "$STATE_FILE"

# }

# json_set() {

#     local FILTER="$1"

#     local TMP

#     TMP=$(mktemp)

#     jq "$FILTER" "$STATE_FILE" > "$TMP"

#     mv "$TMP" "$STATE_FILE"

# }