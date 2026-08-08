#!/bin/bash
# Looks up geolocation data for a given IPv4 address via ipwhois.app.
# Requires: curl, jq

read -p "Enter the target IP: " IP

if [[ -z "$IP" ]]; then
    echo "Input cannot be blank."
    exit 1
fi

curl -s "http://ipwhois.app/json/${IP}" | jq
