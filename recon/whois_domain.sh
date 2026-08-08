#!/bin/bash
# Runs a WHOIS lookup against a target domain.
# Requires: whois

read -p "Enter the target website: " website

if [[ -z "$website" ]]; then
    echo "Input cannot be blank."
    exit 1
fi

whois "$website"
