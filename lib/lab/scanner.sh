#!/bin/bash

###############################################################################
# SERVICE ENUMERATION
###############################################################################

scan_services() {

    local TARGET="$1"

    [[ -z "$TARGET" ]] && fatal "No target supplied."

    info "Scanning services on $TARGET..."

    nmap \
        -Pn \
        -sV \
        -O \
        "$TARGET"

}