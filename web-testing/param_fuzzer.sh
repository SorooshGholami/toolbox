#!/bin/bash
# Sends a list of payloads as URL parameters against a target page —
# useful for testing input validation / SQLi / XSS payload lists on
# an application you own or have authorization to test.
#
# (Renamed from sql_injection.sh — the script itself is a generic
# parameter fuzzer, not SQLi-specific.)
#
# Payload file format:
#   - Single-input mode:  key=value   (one payload per line)
#   - Two-input mode:     username=value&password=value

read -p "Enter the target website or address: " addr
read -p "Enter the vulnerable page path (e.g. /login.php): " page
read -p "Enter the path to the payload file: " payload
read -p "Single input (1) or two inputs, e.g. user+pass (2)? " input_mode

if [[ -z "$addr" || -z "$page" || -z "$payload" ]]; then
    echo "Inputs cannot be blank."
    exit 1
fi

if [[ ! -f "$payload" ]]; then
    echo "Payload file not found: $payload"
    exit 1
fi

ping -c 1 "$addr" > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo -e "\n$addr unreachable"
    exit 1
fi

echo -e "\n\033[1;96mStarting...\033[0m\n"

i=1
while read -r line; do
    echo -e "\033[1;95mPayload No.$i: ($line)\033[0m\n"

    if [[ "$input_mode" == "1" ]]; then
        response=$(curl -s -G "http://${addr}/${page}" --data-urlencode "$line")
    elif [[ "$input_mode" == "2" ]]; then
        username=$(echo "$line" | cut -d '&' -f 1)
        password=$(echo "$line" | cut -d '&' -f 2)
        response=$(curl -s -G "http://${addr}/${page}" --data-urlencode "$username" --data-urlencode "$password")
    else
        echo "Invalid mode. Use 1 or 2."
        exit 1
    fi

    echo -e "\033[1;33m$response\033[0m\n"
    i=$((i + 1))
    echo -e "\033[1;32m-------------------------------------------------------\033[0m"
    sleep 0.1
done < "$payload"

echo -e "\033[1;96m#################### Finished ####################\033[0m"
