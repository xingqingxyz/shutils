import asyncio
import os

import aiohttp
import pyperclip
import requests
from Crypto.Cipher import AES

# linux
"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36 EdgA/116.0.1938.75"
}


def parse_m3u8(text: str):
    iv_hex = key_url = ""
    files = []
    for line in text.split("\n"):
        if line.startswith("#"):
            if not line.startswith("#EXT-X-KEY:"):
                continue
            key_url = line.split("URI=", 1)[1].split(",")[0][1:-1]
            iv_hex = line.split("IV=", 1)[1].split(",")[0]
        elif line.endswith(".mp4"):
            files.append(line)
    if not iv_hex:
        raise TypeError("invalid m3u8 text")
    return iv_hex, key_url, files


def compute_slices(time_str: str, time_slice: float):
    time = time_str.split(":")
    match len(time):
        case 2:
            return int((int(time[0]) * 60 + int(time[1])) / time_slice) + 2
        case 3:
            return (
                int(
                    (int(time[0]) * 3600 + int(time[1]) * 60 + int(time[2]))
                    / time_slice
                )
                + 2
            )
    return 0


def save_on_disk(contents, filename: str):
    with open(filename, "wb") as f:
        f.writelines(contents)
    print(f"saved to: {filename}")


async def download_videos(
    base_url: str,
    files: list[str],
    cipher,
    headers=HEADERS,
):
    errors = {}
    error_cnt = 0
    contents = [None] * len(files)

    async def download_file(i: int, file: str):
        nonlocal error_cnt
        try:
            content = await (await session.get(file)).content.read()
            content = cipher.decrypt(content)
            contents[i] = content
            print(i, end="\r")
        except Exception as e:
            errors[i] = e
            print(f"\nerror: ({i}) {e}")
            error_cnt += 1

    async with aiohttp.ClientSession(base_url, headers=headers) as session:
        tasks = [
            asyncio.create_task(download_file(i, file)) for i, file in enumerate(files)
        ]
        await asyncio.wait(tasks)

    print("error_cnt: ", error_cnt)
    if errors:
        print(errors)
    return filter(bool, contents)


def get(
    *,
    base_url: str,
    files: list[str],
    iv_hex: str,
    key: str,
    outfile: str,
):
    cipher = AES.new(bytes(key, "utf8"), AES.MODE_CBC, IV=bytes.fromhex(iv_hex[2:]))

    contents = asyncio.run(download_videos(base_url, files, cipher, HEADERS))

    try:
        save_on_disk(contents, outfile)
    except Exception:
        save_on_disk(contents, os.path.basename(outfile))


def main():
    m3u8 = parse_m3u8(pyperclip.paste())
    base_url = input("base_url: ")
    outfile = input("outfile: ")
    key = requests.get(str(base_url + m3u8[1]), headers=HEADERS).text
    get(
        base_url="",
        files=m3u8[2],
        iv_hex=m3u8[0],
        key=key,
        outfile=outfile,
    )


if __name__ == "__main__":
    main()
