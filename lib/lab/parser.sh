#!/bin/bash

parse_discovery(){

local FILE="$1"

xmllint \
--xpath "//host" \
"$FILE"

}