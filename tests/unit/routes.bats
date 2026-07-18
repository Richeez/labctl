#!/usr/bin/env bats

load ../helpers/common.bash

@test "Default route available" {

    run default_route

    [ "$status" -eq 0 ]

}