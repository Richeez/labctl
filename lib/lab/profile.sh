#!/bin/bash

###############################################################################
# Profiles
###############################################################################

profile_kioptrix(){

info "Preparing Kioptrix Lab..."

activate_connection contain

discover_network

generate_report

}

profile_metasploitable(){

info "Preparing Metasploitable Lab..."

activate_connection contain

discover_network

generate_report

}