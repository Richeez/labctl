#!/usr/bin/env bats

load ../helpers/common.bash

@test "Version exists" {

    [ -n "$VERSION" ]

}

@test "NAT interface configured" {

    [ -n "$NAT_DEV" ]

}