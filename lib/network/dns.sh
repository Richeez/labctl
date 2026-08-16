#!/usr/bin/env bash

###############################################################################
# LABCTL DNS
###############################################################################

network_dns() {

    local DNS_SERVERS=""

    if command -v resolvectl >/dev/null 2>&1; then

        DNS_SERVERS="$(
            resolvectl dns 2>/dev/null |
                awk '
                    {
                        for (i = 2; i <= NF; i++) {
                            if ($i ~ /^[0-9a-fA-F:.]+$/) {
                                print $i
                            }
                        }
                    }
                ' |
                paste -sd ' ' -
        )"

    fi


    ###########################################################################
    # Fallback to resolv.conf
    ###########################################################################

    if [[ -z "$DNS_SERVERS" && -f /etc/resolv.conf ]]; then

        DNS_SERVERS="$(
            awk '
                $1 == "nameserver" {
                    print $2
                }
            ' /etc/resolv.conf |
            paste -sd ' ' -
        )"

    fi


    printf '%s\n' "$DNS_SERVERS"
}