import ctypes
import json
import os
import platform
import re
import tempfile
import time
from argparse import ArgumentParser
from fnmatch import fnmatch
from logging import warning
from typing import TypedDict

HOME = os.path.expanduser("~")


def get_windows_drives():
    bitmask: int = ctypes.windll.kernel32.GetLogicalDrives()
    drives: list[str] = []
    for i in range(26):
        if bitmask & (1 << i):
            drives.append(f"{chr(65 + i)}:\\")
    return drives


class ZItem(TypedDict):
    rank: float
    time: int
    path: str


class ZConfig:
    datafile = f"{HOME}/.z.json"
    max_history = 1000
    exclude_patterns = [
        HOME,
        os.path.join(tempfile.gettempdir(), "*"),
    ]
    if platform.uname().system == "Windows":
        exclude_patterns.extend(get_windows_drives())
    else:
        exclude_patterns.append("/")


class Z:
    def __init__(self):
        self.items_map: dict[str, ZItem] = {}
        self.rank_sum = 0.0

    def load_data(self):
        with open(ZConfig.datafile, encoding="utf8") as f:
            items: list[ZItem] = json.load(f)
            self.items_map = {i["path"]: i for i in items}
            self.rank_sum: float = sum(i["rank"] for i in items)

    def dump_data(self):
        with open(ZConfig.datafile, "w", encoding="utf8") as f:
            json.dump(list(self.items_map.values()), f)

    def add(self, paths: list[str]):
        self.load_data()
        now = int(time.time())
        rank_sum = self.rank_sum
        for path in paths:
            try:
                path = os.path.realpath(path)
            except FileNotFoundError:
                continue
            if any(map(lambda p: fnmatch(path, p), ZConfig.exclude_patterns)):
                continue
            if path not in self.items_map:
                self.items_map[path] = {"rank": 1.0, "time": now, "path": path}
            else:
                item = self.items_map[path]
                item["rank"] += 1.0
                item["time"] = now
            rank_sum += 1.0
        if rank_sum > ZConfig.max_history:
            rank_sum = 0.0
            for item in self.items_map.values():
                item["rank"] *= 0.99
                if item["rank"] > 1.0:
                    del self.items_map[item["path"]]
                else:
                    rank_sum += item["rank"]
        if rank_sum != self.rank_sum:
            self.rank_sum = rank_sum
            self.dump_data()

    def delete(self, paths: list[str]):
        self.load_data()
        rank_sum = self.rank_sum
        for path in paths:
            try:
                path = os.path.realpath(path)
            except FileNotFoundError:
                continue
            if path in self.items_map:
                rank_sum -= self.items_map[path]["rank"]
                del self.items_map[path]
        if rank_sum != self.rank_sum:
            self.rank_sum = rank_sum
            self.dump_data()

    def main(
        self,
        *,
        echo=False,
        list_=False,
        list_path=False,
        rank=False,
        time_=False,
        cwd=False,
        queries: list[str] = [],
    ):
        self.load_data()
        paths = self.items_map.keys()
        # use (?i) or (?i:...) to ignore case
        re_query = f"^.*{'.*'.join(queries)}.*$"
        if platform.system() == "Windows":
            re_query = re_query.replace("/", r"\\")
        try:
            re_query = re.compile(re_query)
            paths = filter(lambda x: re_query.match(x), paths)
        except:  # noqa: E722
            pass
        if cwd:
            pwd = os.getcwd() + os.sep
            paths = filter(lambda x: x.startswith(pwd), paths)
        paths = list(paths)
        if not paths:
            if queries and fnmatch(queries[-1], "*[\\/]*"):
                print(queries[-1])
                exit(99)
            warning(f"no matches for regexp {re_query}")
            return
        items = [self.items_map[p] for p in paths]
        if rank:
            items.sort(key=lambda x: x["rank"])
        elif time_:
            items.sort(key=lambda x: x["time"])
        else:
            now = int(time.time())
            items.sort(
                key=lambda x: (
                    10000 * x["rank"] * (3.75 / (0.0001 * (now - x["time"]) + 1.25))
                )
            )
        if list_:
            print("\n".join(map(str, items)))
            return
        elif list_path:
            print("\n".join(i["path"] for i in items))
            return
        elif echo:
            print(items[-1])
            return
        rank_sum = self.rank_sum
        found = False
        for item in reversed(items):
            if os.path.isdir(item["path"]):
                found = True
                print(item["path"])
                break
            warning(f"directory not exist, removing it: {item['path']}")
            del self.items_map[item["path"]]
            rank_sum -= item["rank"]
        if rank_sum != self.rank_sum:
            self.rank_sum = rank_sum
            self.dump_data()
        if found:
            exit(99)


def main():
    parser = ArgumentParser(description="Z, jumps to most frecently used directory.")
    group = parser.add_argument_group("Add")
    group.add_argument(
        "-a",
        "--add",
        nargs="+",
        help="add directories to z data file, the last option",
    )
    group = parser.add_argument_group("Delete")
    group.add_argument(
        "-d",
        "--delete",
        nargs="+",
        help="delete directories from z data file, the last option",
    )
    group = parser.add_argument_group("Main")
    group.add_argument("-r", "--rank", action="store_true", help="sort by rank")
    group.add_argument(
        "-t", "--time", dest="time_", action="store_true", help="sort by time"
    )
    group.add_argument("-c", "--cwd", action="store_true", help="search in cwd")
    group.add_argument("-e", "--echo", action="store_true", help="echo it, not cd")
    group.add_argument(
        "-l", "--list", dest="list_", action="store_true", help="list all matches"
    )
    group.add_argument(
        "-L", dest="list_path", action="store_true", help="list all matches path"
    )
    group.add_argument("queries", nargs="*", help="z queries")

    args = parser.parse_args()
    z = Z()
    if args.add:
        z.add(args.add)
    elif args.delete:
        z.delete(args.delete)
    else:
        del args.__dict__["add"]
        del args.__dict__["delete"]
        z.main(**args.__dict__)


if __name__ == "__main__":
    main()
