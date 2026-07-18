#!/usr/bin/env bats

load ../helpers/common.bash

@test "eth0 exists" {

    run interface_exists "$NAT_DEV"

    [ "$status" -eq 0 ]

}

@test "eth1 exists" {

    run interface_exists "$HOSTONLY_DEV"

    [ "$status" -eq 0 ]

}