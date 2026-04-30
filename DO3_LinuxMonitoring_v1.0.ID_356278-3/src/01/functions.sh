#!/bin/bash

number() {
    local param="$1"
    if [[ $param =~ ^[+-]?([0-9]+([.][0-9]+)?|[.][0-9]+)$ ]]; then
        return 0
    else
        return 1
    fi
}