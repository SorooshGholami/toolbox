#!/usr/bin/env python3
"""
Fetches an auth token from RestfulSms.com's API and saves the response
to token.txt (used by send_message.py).

Credentials are never hardcoded. Provide them via environment variables:
    export SMS_API_KEY="your-user-api-key"
    export SMS_SECRET_KEY="your-secret-key"

Intended to run periodically via cron, e.g.:
    */25 * * * * cd /path/to/sms-notifier && python3 get_token.py
"""

import json
import os
import sys

import requests

API_KEY = os.environ.get("SMS_API_KEY")
SECRET_KEY = os.environ.get("SMS_SECRET_KEY")
TOKEN_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "token.txt")


def main():
    if not API_KEY or not SECRET_KEY:
        print("Set SMS_API_KEY and SMS_SECRET_KEY environment variables.")
        sys.exit(1)

    url = "https://RestfulSms.com/api/Token"
    body = {"UserApiKey": API_KEY, "SecretKey": SECRET_KEY}
    headers = {"content-type": "application/json"}

    response = requests.post(url, data=json.dumps(body), headers=headers)
    result = response.json()

    with open(TOKEN_FILE, "w", encoding="utf-8") as f:
        json.dump({"status_code": response.status_code, "response": result}, f, ensure_ascii=False, indent=2)

    print(f"Status Code {response.status_code}")


if __name__ == "__main__":
    main()
