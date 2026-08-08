#!/bin/bash
# Pings a host once and reports whether it's reachable.
# Requires: ping

read -p "Enter the target host: " host

if [[ -z "$host" ]]; then
    echo "Input cannot be blank."
    exit 1
fi

regex='[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

if [[ ! $host =~ $regex ]]; then
    echo "Not a valid input."
    exit 1
fi

ping -c 1 "$host" > /dev/null 2>&1
return_code=$?

if [[ "$return_code" -eq 0 ]]; then
    echo -e "\n$host reachable"
else
    echo -e "\n$host unreachable"
fi
