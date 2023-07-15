# Generated from ~/dotfiles/system.org

import imaplib
import subprocess
import pathlib
import logging

LOGFILE = pathlib.Path().home() / ".local/share/qtile/mailwatcher.log"
logger = logging.getLogger(__name__)
handler = logging.FileHandler(LOGFILE)
logger.addHandler(handler)

def main():

    email = subprocess.run(
        ["pass", "email_user"],
        check=True,
        capture_output=True,
        encoding="utf-8",
    ).stdout.strip()
    password = subprocess.run(
        ["pass", "email_password"],
        check=True,
        capture_output=True,
        encoding="utf-8",
    ).stdout.strip()
    SMTP_SERVER = "imap.gmail.com"
    SMTP_PORT = 993

    mail = imaplib.IMAP4_SSL(SMTP_SERVER)
    mail.login(email, password)
    mail.select("inbox")
    _, mail_ids = mail.search(None,"UNSEEN")
    unread = len(mail_ids[0].split())
    return str(unread)

def main_wrapper():
    try:
        return main()
    except Exception as e:
        logger.exception(e)
        return "Err"

if __name__ == "__main__":
    main_wrapper()
