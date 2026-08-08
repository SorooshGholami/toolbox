#!/usr/bin/env python3
"""
Sends an SMS via RestfulSms.com using the token saved by get_token.py.

Provide the message details via environment variables:
    export SMS_LINE_NUMBER="your-line-number"
    export SMS_TO="09300000000"            # comma-separated for multiple recipients
    export SMS_TEXT="سلام"

(Renamed variables and switched to proper JSON parsing of token.txt instead
of fragile string-slicing — the original assumed a fixed line layout that
would break if the API response format ever changed.)
"""

import json
import os
import sys

import requests

TOKEN_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "token.txt")


def load_token() -> str:
    if not os.path.exists(TOKEN_FILE):
        print("token.txt not found — run get_token.py first.")
        sys.exit(1)

    with open(TOKEN_FILE, encoding="utf-8") as f:
        data = json.load(f)

    if data.get("status_code") != 201:
        print("Cannot read the token — last token request was not successful.")
        sys.exit(1)

    return data["response"]["TokenKey"]


def main():
    line_number = os.environ.get("SMS_LINE_NUMBER")
    recipients = os.environ.get("SMS_TO")
    text = os.environ.get("SMS_TEXT")

    if not line_number or not recipients or not text:
        print("Set SMS_LINE_NUMBER, SMS_TO, and SMS_TEXT environment variables.")
        sys.exit(1)

    token = load_token()

    url = "https://RestfulSms.com/api/MessageSend"
    body = {
        "Messages": [text],
        "MobileNumbers": [n.strip() for n in recipients.split(",")],
        "LineNumber": line_number,
        "SendDateTime": "",
        "CanContinueInCaseOfError": "false",
    }
    headers = {"content-type": "application/json", "x-sms-ir-secure-token": token}

    response = requests.post(url, data=json.dumps(body), headers=headers)

    print("Status Code", response.status_code)
    print("JSON Response", response.json())


if __name__ == "__main__":
    main()
