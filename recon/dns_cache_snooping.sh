#!/bin/bash
# Checks whether a DNS server has a record cached (non-recursive query),
# then estimates cache age via the TTL of a recursive query.
# Requires: dig

read -p "Enter the target DNS server: " dns
read -p "Enter the target address: " addr

if [[ -z "$dns" || -z "$addr" ]]; then
    echo "Inputs cannot be blank."
    exit 1
fi

norecurse=$(dig "@$dns" "$addr" A +norecurse)

if [[ $norecurse == *"NOERROR"* ]]; then
    echo -e "\nNon-recursive query succeeded:"
    echo "$norecurse"

    recurse_ttl=$(dig "@$dns" "$addr" A +recurse | awk 'NR==15 {print $2}')

    if [[ -n "$recurse_ttl" && "$recurse_ttl" -lt 300 ]]; then
        echo -e "\nRecord likely cached recently — TTL: $recurse_ttl"
    fi
else
    echo "Server did not return NOERROR — target may not be cached or resolvable."
    exit 1
fi
