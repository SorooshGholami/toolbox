#!/bin/bash
# Extracts and lists all outgoing links from a target webpage.
# Requires: lynx

read -p "Enter the target website: " website

if [[ -z "$website" ]]; then
    echo "Input cannot be blank."
    exit 1
fi

lynx -dump -listonly "$website"
