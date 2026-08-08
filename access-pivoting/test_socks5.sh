#!/bin/bash
# Tests connectivity through a SOCKS5 proxy against a target URL.
#
# Usage: ./test_socks5.sh <proxy_ip:port> [target_url]

proxy="$1"
target="${2:-http://www.google.com}"

if [[ -z "$proxy" ]]; then
    echo "Usage: $0 <proxy_ip:port> [target_url]"
    echo "Example: $0 127.0.0.1:1080 http://www.google.com"
    exit 1
fi

curl -v --max-time 10 --socks5 "$proxy" "$target"
