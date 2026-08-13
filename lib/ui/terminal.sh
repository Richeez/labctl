#!/usr/bin/env bash

terminal_width() {

    tput cols 2>/dev/null || echo 80

}

terminal_clear() {

    clear

}