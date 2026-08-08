#!/bin/bash
# Checks whether a host exposes NFS via RPC, and lists its exports if so.
# Requires: rpcinfo, showmount (nfs-common / nfs-utils)

read -p "Enter the target address: " addr

if [[ -z "$addr" ]]; then
    echo "Input cannot be blank."
    exit 1
fi

rpc=$(rpcinfo -p "$addr" 2>/dev/null)

if [[ $rpc == *"nfs"* ]]; then
    showmount -e "$addr"
else
    echo "No NFS service found on $addr, or host unreachable."
    exit 1
fi
