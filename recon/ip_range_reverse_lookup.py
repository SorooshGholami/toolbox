#!/usr/bin/env python3
"""
Performs reverse DNS lookup (PTR record) for every IP address in a given CIDR range.
Requires: netaddr  (pip install netaddr)
"""

import socket
import time

from netaddr import IPNetwork


class Colors:
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def main():
    print()
    print(f"{Colors.BOLD}{Colors.CYAN}Enter the target IP with CIDR, e.g. 192.168.1.0/24, "
          f"to reverse-lookup the whole range.{Colors.ENDC}")
    print()

    target = input(f"{Colors.BOLD}{Colors.BLUE}Enter the target network: {Colors.ENDC}").strip()

    try:
        ip_list = [str(ip) for ip in IPNetwork(target)]
    except Exception as exc:
        print(f"Invalid network: {exc}")
        return

    for ip in ip_list:
        try:
            domain_name = socket.gethostbyaddr(ip)[0]
            print(f"\nReverse lookup of {ip}: {domain_name}")
            print("=" * 60)
        except (socket.herror, socket.gaierror):
            print(f"\n{ip} — no PTR record")
            print("-" * 40)
        time.sleep(0.02)


if __name__ == "__main__":
    main()
