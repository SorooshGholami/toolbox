#!/bin/bash
# Fetches a list of live SOCKS5 proxies from geonode.com and appends them to
# proxychains4.conf, then restarts tor.
#
# WARNING: This modifies /etc/proxychains4.conf and restarts a system service.
# Requires: curl, awk, sed, proxychains4, root privileges.

proxy_list_url="https://proxylist.geonode.com/api/proxy-list?limit=10&page=1&sort_by=lastChecked&sort_type=desc&protocols=socks5"

ips=($(curl -s "$proxy_list_url" | sed -e 's/[{}]//g' | awk -v RS=',"' -F: '/^ip/ {print $2}' | sed 's/"//g'))
ports=($(curl -s "$proxy_list_url" | sed -e 's/[{}]//g' | awk -v RS=',"' -F: '/^port/ {print $2}' | sed 's/"//g'))

conf_file="/etc/proxychains4.conf"

if [[ ! -w "$conf_file" ]]; then
    echo "Cannot write to $conf_file — run as root."
    exit 1
fi

for i in "${!ips[@]}"; do
    echo "socks5 ${ips[$i]} ${ports[$i]}" >> "$conf_file"
    sleep 0.1
done

if [[ $? -eq 0 ]]; then
    echo "Proxies added successfully."
    service tor restart
else
    echo "Failed to add proxies."
    exit 1
fi
