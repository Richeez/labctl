#!/usr/bin/env bats

@test "Update command runs" {

    run sudo labctl update

    [ "$status" -eq 0 ]

}