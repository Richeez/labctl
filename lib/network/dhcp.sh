#!/bin/bash

###############################################################################
# DHCP Manager
###############################################################################

renew_dhcp() {

    local IFACE="$1"

    info "Renewing DHCP lease on $IFACE..."

    nmcli device disconnect "$IFACE" >/dev/null 2>&1 || true

    sleep 1

    nmcli device connect "$IFACE"

}

wait_for_ip() {

    local IFACE="$1"

    local COUNT=0

    while [[ -z "$(interface_ip "$IFACE")" ]]
    do

        sleep 1

        ((COUNT++))

        if (( COUNT >= DHCP_TIMEOUT ))
        then
            return 1
        fi

    done

    return 0

}

release_dhcp() {

    local IFACE="$1"

    nmcli device disconnect "$IFACE"

}