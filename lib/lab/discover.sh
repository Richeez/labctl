#!/bin/bash

###############################################################################
# HOST DISCOVERY
###############################################################################



discover_network(){

    local IFACE SUBNET OUTPUT IP HOST MAC

    IFACE="$(network_default_interface)"
    [[ -n "$IFACE" ]] || {
        log_error "No default network interface is available."
        return 1
    }

    SUBNET="$(interface_cidr "$IFACE" | head -n1)"
    [[ -n "$SUBNET" ]] || {
        log_error "Unable to determine the subnet for '$IFACE'."
        return 1
    }

    init_inventory || return 1
    log_info "Discovering hosts on $SUBNET..."

    OUTPUT="$(nmap -sn -oG - "$SUBNET")" || return 1

    while IFS=$'\t' read -r IP HOST MAC; do
        [[ -n "$IP" ]] || continue
        inventory_add "$IP" "$MAC" "$HOST" "unknown" || return 1
    done < <(
        awk '/Status: Up/ {
            ip=$2; host=$3; sub(/\(.*/, "", host)
            mac=""
            if (index($0, "MAC Address: ")) {
                split($0, fields, "MAC Address: ")
                split(fields[2], mac_fields, " ")
                mac=mac_fields[1]
            }
            print ip "\t" host "\t" mac
        }' <<< "$OUTPUT"
    )

    inventory_list

}
# discover_network() {

#     local DEV

#     DEV=$(default_interface)

#     [[ -z "$DEV" ]] && fatal "No active interface."

#     local SUBNET

#     SUBNET=$(interface_cidr "$DEV")

#     info "Scanning $SUBNET..."

#     sudo nmap \
#         -sn \
#         "$SUBNET"

# }
