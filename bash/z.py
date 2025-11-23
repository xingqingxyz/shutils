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
        if not os.path.exists(ZConfig.datafile):
            self.itemsMap = {}
            self.rankSum = 0.0
            return
        with open(ZConfig.datafile, encoding="utf8") as f:
            o = json.load(f)
            self.itemsMap: dict[str, ZItem] = o["itemsMap"]
            self.rankSum: float = o["rankSum"]

    def dump_data(self):
        with open(ZConfig.datafile, "w", encoding="utf8") as f:
            json.dump(self.__dict__, f)

    def add(self, paths: list[str]):
        sum = self.rankSum
        for path in paths:
            try:
                path = os.path.realpath(path)
            except FileNotFoundError:
                continue
            if any(map(lambda p: fnmatch(path, p), ZConfig.exclude_patterns)):
                continue
            if path not in self.itemsMap:
                self.itemsMap[path] = {"rank": 0.0, "time": 0}
            item = self.itemsMap[path]
            item["rank"] += 1.0
            item["time"] = int(time.time())
            sum += 1.0
        if sum > ZConfig.max_history:
            sum = 0.0
            for key, value in self.itemsMap.items():
                value["rank"] *= 0.99
                if value["rank"] > 1.0:
                    del self.itemsMap[key]
                else:
                    sum += value["rank"]
        if sum != self.rankSum:
            self.rankSum = sum
            self.dump_data()

    def delete(self, paths: list[str]):
        sum = self.rankSum
        for path in paths:
            try:
                path = os.path.realpath(path)
            except FileNotFoundError:
                continue
            if path in self.itemsMap:
                sum -= self.itemsMap[path]["rank"]
                del self.itemsMap[path]
        if sum != self.rankSum:
            self.rankSum = sum
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
        items = self.itemsMap.items()
        # use (?i) or (?i:...) to ignore case
        re_query = f"^.*{'.*'.join(queries)}.*$"
        if platform.system() == "Windows":
            re_query = re_query.replace("/", r"\\")
        try:
            re_query = re.compile(re_query)
            items = filter(lambda x: re_query.match(x[0]), items)
        finally:
            # maybe raw glob match on last word
            pass
        if cwd:
            pwd = os.getcwd() + os.sep
            items = filter(lambda x: x[0].startswith(pwd), items)
        items = list(items)
        if not items:
            if queries and fnmatch(queries[-1], "*[\\/]*"):
                print(queries[-1])
                exit(99)
            warning(f"no matches for regexp {re_query}")
            return
        if rank:
            items.sort(key=lambda x: x[1]["rank"])
        elif time_:
            items.sort(key=lambda x: x[1]["time"])
        else:
            now = int(time.time())
            items.sort(
                key=lambda x: 10000
                * x[1]["rank"]
                * (3.75 / (0.0001 * (now - x[1]["time"]) + 1.25))
            )
        if list_:
            print("\n".join(map(str, items)))
            return
        elif list_path:
            print("\n".join(i[0] for i in items))
            return
        elif echo:
            print(items[-1][0])
            return
        sum = self.rankSum
        found = False
        for item in reversed(items):
            if os.path.isdir(item[0]):
                found = True
                print(item[0])
                break
            warning("directory not exist, removing it: " + item[0])
            del self.itemsMap[item[0]]
            sum -= item[1]["rank"]
        if sum != self.rankSum:
            self.rankSum = sum
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
