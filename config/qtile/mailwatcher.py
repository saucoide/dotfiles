#!/home/saucoide/saucoidenv/bin/python
import imaplib
import keyring
from pathlib import Path

def main():

    EMAIL = keyring.get_password('Passwords', 'email_user')
    PW = keyring.get_password('Passwords', 'email_pw')
    SMTP_SERVER = "imap.gmail.com"
    SMTP_PORT = 993

    mail = imaplib.IMAP4_SSL(SMTP_SERVER)
    mail.login(EMAIL,PW)
    mail.select("inbox")
    _, mail_ids = mail.search(None,"UNSEEN")
    unread = len(mail_ids[0].split())

    return f"🖂 {unread}"

if __name__ == "__main__":
    main()
