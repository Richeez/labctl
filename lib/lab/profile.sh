#!/bin/bash

###############################################################################
# Profiles
###############################################################################

profile_kioptrix(){

log_info "Preparing Kioptrix lab..."

network_contain || return

discover_network

generate_report

}

profile_metasploitable(){

log_info "Preparing Metasploitable lab..."

network_contain || return

discover_network

generate_report

}
