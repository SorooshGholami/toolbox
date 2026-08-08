#!/usr/bin/env python3
"""
Fetches a URL and prints the HTTP status code and raw response body.

(Renamed from sql_injection2.py — it's a plain URL fetcher, not
SQLi-specific.)
"""

import urllib.request


def main():
    url = input("Enter the full URL: ").strip()

    with urllib.request.urlopen(url) as response:
        print(f"Result code: {response.getcode()}")
        data = response.read()
        print(data)


if __name__ == "__main__":
    main()
