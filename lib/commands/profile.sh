#!/bin/bash

run(){

require_root

case "$1" in

kioptrix)

profile_kioptrix

;;

metasploitable)

profile_metasploitable

;;

*)

echo

echo "Usage"

echo

echo "labctl profile kioptrix"

echo "labctl profile metasploitable"

;;

esac

}