#!/home/saucoide/saucoidenv/bin/python
import imaplib
from pathlib import Path

def main():

    cstore = Path.home() / ".config/.userdata/.mailwatcher/cstore"
    store = {key:val.rstrip() for key,val in (line.split("=") for line in open(cstore))}
    EMAIL = store["U"]
    PW = store["P"]
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
