# 📱 sms-notifier

Two small scripts that fetch an auth token from RestfulSms.com and send an
SMS through it. Meant to run as a cron job that refreshes the token
periodically, so `send_message.py` always has a valid one available.

## ⚠️ Before publishing

The original version of this project had a **live API key, secret key, and
an active session token** hardcoded/saved in plaintext. If you haven't
already, **revoke/regenerate them in your RestfulSms.com dashboard** —
that data being exposed anywhere (even briefly, even in a private repo)
means it should be treated as compromised.

`token.txt` is a runtime-generated file (holds a live session token) and
must never be committed. It's in `.gitignore` below for that reason.

## Setup

```bash
pip install requests
```

Set your credentials as environment variables (don't hardcode them):

```bash
export SMS_API_KEY="your-user-api-key"
export SMS_SECRET_KEY="your-secret-key"
export SMS_LINE_NUMBER="your-line-number"
export SMS_TO="09300000000"          # comma-separated for multiple recipients
export SMS_TEXT="سلام"
```

## Usage

```bash
python3 get_token.py       # fetches a token, saves it to token.txt
python3 send_message.py    # sends the SMS using the saved token
```

## Cron setup

To keep the token fresh, run `get_token.py` on a schedule. Since cron
doesn't inherit your shell's environment variables, put them directly in
the crontab entry or source an env file:

```cron
*/25 * * * * source /path/to/sms-notifier/.env && cd /path/to/sms-notifier && python3 get_token.py
```

Where `.env` (not committed — see `.gitignore`) exports the variables above.

## What changed from the original

- Removed hardcoded `UserApiKey` / `SecretKey` — now via `SMS_API_KEY` /
  `SMS_SECRET_KEY` env vars.
- Removed hardcoded recipient phone number and line number — now via
  `SMS_TO` / `SMS_LINE_NUMBER` env vars.
- `token.txt` is now written as proper JSON, and `send_message.py` parses
  it with `json.load()` instead of slicing specific lines/characters —
  the original approach would break if the API's response format ever
  changed slightly.
- Removed the personal absolute path (`/home/username/Panel_Sms`) from the
  suggested crontab entry.

## License

MIT
