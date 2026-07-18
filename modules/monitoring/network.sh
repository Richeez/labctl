#!/bin/bash

monitor_network(){

watch -n2 '

echo

ip route

echo

nmcli device

'

}