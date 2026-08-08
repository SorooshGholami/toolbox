#!/usr/bin/env python3
"""
Connects to an IMAP inbox and prints the headers (and payload) of every message.

Credentials are NEVER hardcoded. Provide them via environment variables:
    export IMAP_HOST="imap.gmail.com"
    export IMAP_USER="you@example.com"
    export IMAP_PASS="your-app-password"   # use an App Password, not your real password

If IMAP_PASS is not set, you'll be prompted for it securely (input hidden).

Note: Gmail requires an "App Password" (with 2FA enabled) or OAuth2 —
your normal account password will not work here.
"""

import email
import getpass
import imaplib
import os


def main():
    host = os.environ.get("IMAP_HOST", "imap.gmail.com")
    user = os.environ.get("IMAP_USER") or input("IMAP username/email: ").strip()
    password = os.environ.get("IMAP_PASS") or getpass.getpass("IMAP password (app password): ")

    imap_server = imaplib.IMAP4_SSL(host=host)
    imap_server.login(user, password)
    imap_server.select()  # default is INBOX

    _, message_numbers_raw = imap_server.search(None, "ALL")

    for message_number in message_numbers_raw[0].split():
        _, msg = imap_server.fetch(message_number, "(RFC822)")
        message = email.message_from_bytes(msg[0][1])

        print("== Mail Header =====")
        print(message)
        print("== Additional Mail details =====")
        print(f"Multipart?: {message.is_multipart()}")

        if message.is_multipart():
            print("Multipart types:")
            for part in message.walk():
                print(f"- {part.get_content_type()}")
            for sub_message in message.get_payload():
                print(f"Payload\n{sub_message.get_payload()}")
        else:
            print(f"Payload\n{message.get_payload()}")

    imap_server.logout()


if __name__ == "__main__":
    main()
