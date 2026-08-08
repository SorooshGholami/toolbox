#!/bin/bash
# Sends a TCP port-knock sequence to a host, then opens an SSH connection.
# Edit the "ports" variable to match your server's configured knock sequence.
# Requires: nmap, ssh

ports="1111 2222 3333"

read -p "Enter the target host: " host
read -p "Enter the SSH user: " user

if [[ -z "$host" || -z "$user" ]]; then
    echo "Inputs cannot be blank."
    exit 1
fi

for port in $ports; do
    nmap -Pn --host-timeout 201 --max-retries 0 -p "$port" "$host"
    sleep 1
done

ssh "${user}@${host}"
