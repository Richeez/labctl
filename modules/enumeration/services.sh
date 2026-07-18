#!/bin/bash

enumerate_services() {

    local TARGET="$1"

    info "Enumerating services..."

    nmap -sV \
         -Pn \
         "$TARGET"

}