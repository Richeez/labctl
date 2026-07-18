#!/bin/bash

###############################################################################
# Network Doctor Task
###############################################################################

network_doctor_task() {

    doctor_header

    doctor_check_dependencies

    doctor_check_configuration

    doctor_check_profiles

    doctor_check_interfaces

    doctor_check_routes

    doctor_check_dns

    doctor_check_virtualbox

    doctor_summary

}