#!/usr/bin/env bash

function display_name() {
    xrandr -q | grep primary | cut -d' ' -f1
}

function is_laptop_display() {
    [ `display_name` == "eDP1" ]
}
