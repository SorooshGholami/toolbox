#!/usr/bin/env python3
"""
Automates submitting a login form on a target page — useful for testing
your own app's login flow (e.g. lockout behavior, rate limiting).

(Renamed from sql_injection.py — it's form-submission automation via
mechanize, not SQL injection. Credentials and the hardcoded target IP
from the original version have been removed.)

Requires: mechanize, beautifulsoup4
    pip install mechanize beautifulsoup4

NOTE: mechanize is largely unmaintained. For new projects consider
`requests` + `BeautifulSoup` (for parsing) or Selenium/Playwright if the
form relies on JavaScript.
"""

import getpass
import http.cookiejar

import mechanize


def main():
    target_url = input("Enter the target URL: ").strip()
    username = input("Username: ").strip()
    password = getpass.getpass("Password: ")

    cj = http.cookiejar.CookieJar()
    br = mechanize.Browser()
    br.set_cookiejar(cj)
    br.open(target_url)

    br.select_form(nr=0)
    br.form["username"] = username
    br.form["password"] = password
    br.submit()

    print(br.response().read())


if __name__ == "__main__":
    main()
