#!/usr/bin/env python3
"""
WhatsApp Web sender.

Reads a message from message.txt (in this project folder) and sends it to a
fixed contact via WhatsApp Web, using an already-authenticated Chrome profile
stored in ./chrome-data.

Must be run as a non-root user (Chrome/ChromeDriver refuse a real sandbox
under root; running as root would require --no-sandbox, which is a security
downgrade). See README.md for setup.
"""

import logging
import os
import sys
import time

from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException, TimeoutException
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

# --------------------------------------------------------------------------
# Configuration
# --------------------------------------------------------------------------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MESSAGE_FILE = os.path.join(BASE_DIR, "message.txt")
CHROME_DATA_DIR = os.path.join(BASE_DIR, "chrome-data")
CHROMEDRIVER_PATH = "/usr/local/bin/chromedriver"
RECIPIENT_NAME = "contact"        # exact WhatsApp contact display name
ELEMENT_WAIT_TIMEOUT = 30        # seconds to wait for any single element

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
log = logging.getLogger("whatsapp_sender")


def read_message(path: str) -> str:
    """Return file contents, or '' if the file is missing/empty."""
    if not os.path.exists(path) or os.path.getsize(path) == 0:
        return ""
    with open(path, "r", encoding="utf-8") as f:
        return f.read().strip()


def clear_message_file(path: str) -> None:
    """Empty the trigger file so a re-run doesn't resend the same message."""
    open(path, "w").close()


def build_driver() -> webdriver.Chrome:
    options = Options()
    options.add_argument(f"--user-data-dir={CHROME_DATA_DIR}")
    options.add_experimental_option("excludeSwitches", ["enable-automation"])
    options.add_experimental_option("useAutomationExtension", False)
    # For a headless server: WhatsApp Web still needs an already-authenticated
    # profile (QR scan can't happen headless). Log in once with a visible
    # browser first, then uncomment the line below for later runs:
    # options.add_argument("--headless=new")

    service = Service(CHROMEDRIVER_PATH)
    driver = webdriver.Chrome(service=service, options=options)
    driver.maximize_window()
    return driver


def send_whatsapp_message(driver: webdriver.Chrome, recipient: str, message: str) -> bool:
    """Open a chat with `recipient` and send `message`. Returns True on success.

    NOTE: WhatsApp Web's DOM changes periodically. If a selector below stops
    matching, open web.whatsapp.com, inspect the element in DevTools, and
    update the corresponding XPath.
    """
    driver.get("https://web.whatsapp.com")
    wait = WebDriverWait(driver, ELEMENT_WAIT_TIMEOUT)

    try:
        # Chat list pane — present once logged in (not present at QR screen).
        wait.until(EC.presence_of_element_located((By.XPATH, "//div[@id='pane-side']")))
    except TimeoutException:
        log.error("WhatsApp Web didn't load a logged-in session (QR scan may be required).")
        return False

    try:
        contact = wait.until(
            EC.element_to_be_clickable((By.XPATH, f"//span[@title='{recipient}']"))
        )
        contact.click()
    except TimeoutException:
        log.error("Contact '%s' not found in the chat list.", recipient)
        return False

    try:
        message_box = wait.until(
            EC.presence_of_element_located(
                (By.XPATH, "//footer//div[@contenteditable='true'][@data-tab]")
            )
        )
        message_box.click()
        for i, line in enumerate(message.split("\n")):
            if i > 0:
                message_box.send_keys(Keys.SHIFT, Keys.ENTER)  # newline within the box
            message_box.send_keys(line)
        message_box.send_keys(Keys.ENTER)  # actually send
    except (TimeoutException, NoSuchElementException) as e:
        log.error("Failed to send message: %s", e)
        return False

    return True


def main() -> int:
    message = read_message(MESSAGE_FILE)
    if not message:
        log.info("message.txt is empty or missing — nothing to send.")
        return 0

    driver = None
    try:
        driver = build_driver()
        if send_whatsapp_message(driver, RECIPIENT_NAME, message):
            log.info("Message sent to '%s'.", RECIPIENT_NAME)
            clear_message_file(MESSAGE_FILE)
            time.sleep(3)  # let the send finish registering before closing
            return 0
        log.error("Send failed — leaving message.txt untouched so it can be retried.")
        return 1
    finally:
        if driver is not None:
            driver.quit()  # fully ends the session/process, unlike .close()


if __name__ == "__main__":
    sys.exit(main())
