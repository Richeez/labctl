#!/usr/bin/env bats

@test "Version executes" {

    run labctl version

    [ "$status" -eq 0 ]

}