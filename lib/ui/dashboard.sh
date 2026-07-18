#!/bin/bash

###############################################################################
# Dashboard
###############################################################################



dashboard() {

    echo
    echo "========== LABCTL STATUS =========="
    echo

    echo "Active connections:"
    nmcli -t -f NAME,DEVICE connection show --active

    echo
    echo "Default interface : $(network_default_interface)"
    echo "Default gateway   : $(network_default_gateway)"

    echo
    echo "IP Addresses:"
    ip -brief addr

    echo
}

# dashboard() {

#     clear

#     banner

#     echo
#     echo "=============================================================="
#     printf "%-12s %-10s %-18s %-20s\n" "DEVICE" "STATE" "IP" "PROFILE"
#     echo "=============================================================="

#     while IFS=: read -r DEVICE TYPE STATE CONNECTION
#     do
#         [[ "$DEVICE" == "lo" ]] && continue

#         IP=$(interface_ip "$DEVICE")

#         printf "%-12s %-10s %-18s %-20s\n" \
#             "$DEVICE" \
#             "$STATE" \
#             "${IP:---}" \
#             "${CONNECTION:---}"

#     done < <(
#         nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device
#     )

#     echo
#     echo "Default Interface : $(default_interface)"
#     echo "Gateway           : $(default_gateway)"
#     echo "Current Mode      : $(json_get '.mode')"
#     echo "Last Switch       : $(json_get '.last_switch')"
#     echo

# }