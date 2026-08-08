# whatsapp-sender

Sends whatever text is in `message.txt` to a fixed WhatsApp contact via
WhatsApp Web, using Selenium and an already-authenticated Chrome profile.

## Requirements

- Python 3.9+
- Google Chrome installed
- ChromeDriver matching your installed Chrome version, at `/usr/local/bin/chromedriver`
  (update `CHROMEDRIVER_PATH` in `app.py` if yours lives elsewhere)
- A **non-root** user to run the script (Chrome/ChromeDriver need a real
  sandbox; root would require `--no-sandbox`, which weakens isolation)

## Setup

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Open `app.py` and set `RECIPIENT_NAME` to the exact WhatsApp display name of
the contact you want to message (currently `"Madar"`).

## First run (one-time login)

The first time you run the script, `chrome-data/` doesn't exist yet, so
Chrome will show WhatsApp Web's QR login screen. Scan it with your phone.
The session is then persisted in `chrome-data/`, so subsequent runs skip
the QR step — until the session expires or is logged out from the phone.

## Usage

1. Write the message you want to send into `message.txt`.
2. Run:
   ```bash
   python3 app.py
   ```
3. On success, `message.txt` is automatically cleared so the same message
   isn't resent on the next run. On failure, it's left untouched so you can
   retry.

Logs print to stdout; redirect to a file if running from cron:
```bash
python3 app.py >> whatsapp-sender.log 2>&1
```

## Known limitations

- **Selectors are fragile.** The script locates the contact and message box
  using XPath tied to WhatsApp Web's current DOM. WhatsApp updates its web
  UI periodically, which can break these selectors — if the script starts
  failing to find the contact or message box, inspect the page in Chrome
  DevTools and update the XPath in `send_whatsapp_message()`.
- **Single, hardcoded recipient.** To support multiple recipients you'd
  need to parameterize `RECIPIENT_NAME` (e.g. via a CLI argument or a
  `recipient:message` format in `message.txt`).
- **Not the official API.** This automates the WhatsApp Web client rather
  than using WhatsApp's Business API, which is against WhatsApp's Terms of
  Service and carries some risk of the number being flagged, particularly
  under frequent/scheduled use.

## Project structure

```
whatsapp-sender/
├── app.py            # main script
├── message.txt        # message to send (edit this, then run app.py)
├── requirements.txt    # Python dependencies
├── .gitignore
└── README.md
```
