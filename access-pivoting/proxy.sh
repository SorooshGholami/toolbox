#!/bin/bash
# Fetches a list of live HTTPS proxies from geonode.com and curls a target
# address through each one in turn.
# Requires: curl, awk, sed

read -p "Enter the target address: " addr

if [[ -z "$addr" ]]; then
    echo "Input cannot be blank."
    exit 1
fi

proxy_list_url="https://proxylist.geonode.com/api/proxy-list?limit=10&page=1&sort_by=lastChecked&sort_type=desc&protocols=https"

ips=($(curl -s "$proxy_list_url" | sed -e 's/[{}]//g' | awk -v RS=',"' -F: '/^ip/ {print $2}' | sed 's/"//g'))
ports=($(curl -s "$proxy_list_url" | sed -e 's/[{}]//g' | awk -v RS=',"' -F: '/^port/ {print $2}' | sed 's/"//g'))

n=0
for i in "${!ips[@]}"; do
    proxy="${ips[$i]}:${ports[$i]}"
    n=$((n + 1))
    echo -e "\nProxy No.$n: $proxy\n"
    curl --max-time 10 "$addr" --proxy "$proxy"
    sleep 0.1
done
