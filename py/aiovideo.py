import asyncio
import os
from urllib.parse import urlparse

import aiohttp
import pyperclip
import requests
from Crypto.Cipher import AES

# linux
"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36 EdgA/116.0.1938.75"
}


def parse_m3u8(text):
    iv_hex = key_url = template_url = ""
    for line in text.split("\n"):
        if line.startswith("#EXT-X-KEY:"):
            key_url = line.split("URI=", 1)[1].split(",")[0][1:-1]
            iv_hex = line.split("IV=", 1)[1].split(",")[0]
        elif line.startswith("#"):
            continue
        elif line.startswith("https://"):
            template_url = line
            break
    if not (iv_hex and template_url):
        raise TypeError("invalid m3u8 text")
    return {"iv_hex": iv_hex, "key_url": key_url, "template_url": template_url}


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
    base_url,
    prefix,
    cipher,
    slices_cnt,
    url_padding,
    headers=HEADERS,
):
    error_ids = {}
    error_cnt = 0
    contents = [None] * slices_cnt

    async def handle_slice(id: int):
        nonlocal error_cnt
        url = f"{prefix}{id:0{url_padding}}.ts"
        try:
            content = await (await session.get(url)).content.read()
            content = cipher.decrypt(content)
            contents[id] = content
            print(id, end="\r")
        except Exception as e:
            error_ids[id] = e
            print(f"\nerror: ({id}) {e}")
            error_cnt += 1

    async with aiohttp.ClientSession(base_url, headers=headers) as session:
        tasks = [asyncio.create_task(handle_slice(i)) for i in range(slices_cnt)]
        await asyncio.wait(tasks)

    print(error_ids)
    print("error_cnt: ", error_cnt)
    return filter(bool, contents)


def get(
    *,
    template_url: str,
    time_str: str,
    iv_hex: str,
    key: str,
    outfile: str,
    time_slice=3.066667,
    url_padding=6,
):
    url = urlparse(template_url)
    base_url = f"{url.scheme}://{url.netloc}"
    prefix = url.path[: -(url_padding + 3)]

    slices_cnt = compute_slices(time_str, time_slice)
    cipher = AES.new(bytes(key, "utf8"), AES.MODE_CBC, IV=bytes.fromhex(iv_hex[2:]))

    contents = asyncio.run(
        download_videos(base_url, prefix, cipher, slices_cnt, url_padding)
    )

    try:
        save_on_disk(contents, outfile)
    except Exception:
        save_on_disk(contents, os.path.basename(outfile))


def main():
    m3u8 = parse_m3u8(pyperclip.paste())
    key = input("key: ")
    time_str = input("time_str: ")
    outfile = input("outfile: ")
    if not key:
        key = requests.get(m3u8["key_url"], headers=HEADERS).text
    if not outfile:
        outfile = m3u8["template_url"].rsplit("/", 1)[1]
    get(
        time_str=time_str,
        outfile=outfile,
        key=key,
        template_url=m3u8["template_url"],
        iv_hex=m3u8["iv_hex"],
    )


if __name__ == "__main__":
    main()
