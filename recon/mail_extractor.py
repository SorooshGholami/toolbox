#!/usr/bin/env python3
"""
Crawls a website (following internal links) and collects email addresses
found in the page text.

Requires: requests, beautifulsoup4, html5lib
    pip install requests beautifulsoup4 html5lib

NOTE: The original version of this script had a bug — the crawl/extraction
logic was outside the while-loop due to indentation, so it only ever
processed the *last* URL popped from the queue instead of every page
discovered during the crawl. That's fixed here.
"""

import re
from collections import deque
from urllib.parse import urlsplit

import requests
from bs4 import BeautifulSoup


def main():
    website = input("Enter the target website: ").strip()

    new_urls = deque([website])
    processed_urls = set()
    emails = set()

    while new_urls:
        url = new_urls.popleft()
        processed_urls.add(url)
        print(f"Processing {url}")

        try:
            response = requests.get(url, timeout=10)
        except (requests.exceptions.MissingSchema, requests.exceptions.ConnectionError):
            continue

        parts = urlsplit(url)
        base_url = f"{parts.scheme}://{parts.netloc}"
        path = url[: url.rfind("/") + 1] if "/" in parts.path else url

        new_emails = set(
            re.findall(r"[a-z0-9.\-+_]+@[a-z0-9.\-+_]+\.[a-z]+", response.text, re.I)
        )
        emails.update(new_emails)

        soup = BeautifulSoup(response.text, "html5lib")

        for anchor in soup.find_all("a"):
            link = anchor.attrs.get("href", "")
            if link.startswith("/"):
                link = base_url + link
            elif not link.startswith("http"):
                link = path + link

            if link not in new_urls and link not in processed_urls:
                new_urls.append(link)

    print("\nEmails found:")
    for email in emails:
        print(email)


if __name__ == "__main__":
    main()
