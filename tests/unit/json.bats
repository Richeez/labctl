#!/usr/bin/env bats

load ../helpers/common.bash

@test "State file exists" {

    init_json

    [ -f "$STATE_FILE" ]

}