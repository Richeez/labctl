#!/usr/bin/env bats

@test "Status executes" {

    run labctl status

    [ "$status" -eq 0 ]

}