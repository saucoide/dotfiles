# Generated from ~/dotfiles/system.org

import requests
import subprocess
import pathlib
import logging


LOGFILE = pathlib.Path().home() / ".local/share/qtile/inoreader.log"
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
    BASE_URL = "https://www.inoreader.com/reader/api/0"
    LOGIN_URL = "https://www.inoreader.com/accounts/ClientLogin"

    username = pass_get("inoreader/user")
    password = pass_get("inoreader/password")
    app_id = pass_get("inoreader/appid")
    app_key = pass_get("inoreader/appkey")

    resp = requests.post(
        LOGIN_URL,
        data={
            "Email": username,
            "Passwd": password,
        },
    )

    content = {}
    for line in resp.text.split("\n"):
        if line:
            key, val = line.split("=")
            content[key] = val

    token = content["Auth"]
    headers = {
        "Authorization": "GoogleLogin auth=" + token,
        "Appid": app_id,
        "AppKey": app_key,
    }

    resp = requests.get(BASE_URL + "/unread-count", headers=headers)
    resp.raise_for_status()
    unreadcounts = resp.json()
    unread = unreadcounts["unreadcounts"][0]["count"]
    return str(unread)


def main_wrapper():
    try:
        return main()
    except Exception as e:
        logger.exception(e)
        return "Err"


if __name__ == "__main__":
    main_wrapper()
