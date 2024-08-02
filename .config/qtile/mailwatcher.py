# Generated from ~/dotfiles/system.org

import imaplib
import subprocess
import pathlib
import logging

LOGFILE = pathlib.Path().home() / ".local/share/qtile/mailwatcher.log"
logger = logging.getLogger(__name__)
handler = logging.FileHandler(LOGFILE)
logger.addHandler(handler)


def pass_get(key: str) -> str:
    return subprocess.run(
        ["pass", key],
        check=True,
        capture_output=True,
        encoding="utf-8",
    ).stdout.strip()


def main():
    email = pass_get("email/user")
    password = pass_get("email/password")
    SMTP_SERVER = "imap.gmail.com"
    SMTP_PORT = 993

    mail = imaplib.IMAP4_SSL(SMTP_SERVER)
    mail.login(email, password)
    mail.select("inbox")
    _, mail_ids = mail.search(None, "UNSEEN")
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
