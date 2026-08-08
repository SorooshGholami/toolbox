#!/bin/bash
# Crawls the links on a target page and scrapes email addresses found on each.
# Requires: lynx, curl

read -p "Enter the target website: " website

if [[ -z "$website" ]]; then
    echo "Input cannot be blank."
    exit 1
fi

sites=$(lynx -dump -listonly "$website")

for site in $sites; do
    echo "$site"
    curl -s "$site" | grep -oE "[a-zA-Z0-9._]+@[a-zA-Z]+\.[a-zA-Z]+"
    echo
    sleep 0.5
done
