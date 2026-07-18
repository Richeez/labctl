#!/bin/bash

run(){

require_root

[[ -z "$1" ]] && fatal "Specify target."

scan_services "$1"

}