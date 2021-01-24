# Generated from ~/dotfiles/system.org

import requests
import keyring
from pathlib import Path

def main():

    BASE_URL = "https://www.inoreader.com/reader/api/0"
    LOGIN_URL = "https://www.inoreader.com/accounts/ClientLogin"

    EMAIL = keyring.get_password("Passwords", 'ino_user')
    PW = keyring.get_password("Passwords", 'ino_pw')
    APP_ID = keyring.get_password("Passwords", 'ino_id')
    APP_KEY = keyring.get_password("Passwords", 'ino_key')


    resp = requests.post(LOGIN_URL, data={'Email':EMAIL,'Passwd':PW})

    content = {}
    for line in resp.text.split('\n'):
        if line:
            key, val = line.split("=")
            content[key] = val
    token = content['Auth']

    headers = {'Authorization': 'GoogleLogin auth=' + token,
            'Appid': APP_ID,
            'AppKey': APP_KEY}

    resp = requests.get(BASE_URL + "/unread-count", headers=headers)
    unreadcounts = resp.json()
    unread = unreadcounts['unreadcounts'][0]['count']

    return str(unread)


if __name__ == "__main__":
    main()
