import os
import re
import time
from argparse import ArgumentParser
from dataclasses import dataclass
from fnmatch import fnmatch
from logging import warning

HOME = os.path.expanduser("~")


@dataclass
class ZItem:
    path: str
    rank: float
    time: int


class ZConfig:
    cmd = "z"
    datafile = f"{HOME}/.z"
    datasep = "|"
    resolve_symlinks = True
    max_history = 1000
    exclude_patterns = [HOME, "/", "/tmp/*"]


class Z:
    def __init__(self):
        self.items_map = {}
        self.rank_sum = 0.0
        self.load_data()

    def get_path(self, path):
        if not ZConfig.resolve_symlinks:
            return os.path.realpath(path, strict=True)
        if not os.path.exists(path):
            raise FileNotFoundError(path)
        return os.path.abspath(path)

    def load_data(self):
        with open(ZConfig.datafile, encoding="utf8") as f:
            for line in f.readlines():
                if not line:
                    continue
                item = line.split(ZConfig.datasep)
                if len(item) != 3:
                    raise TypeError(f"z data file is broken: {ZConfig.datafile}")
                item = ZItem(item[0], float(item[1]), int(item[2]))
                self.items_map[item.path] = item
                self.rank_sum += item.rank

    def dump_data(self):
        with open(ZConfig.datafile, "w", encoding="utf8") as f:
            for item in self.items_map.values():
                f.write(
                    f"{item.path}{ZConfig.datasep}{item.rank}{ZConfig.datasep}{item.time}\n"
                )

    def add(self, paths: list[str]):
        rank_sum = self.rank_sum
        for path in paths:
            try:
                path = self.get_path(path)
            except FileNotFoundError:
                continue
            if any(map(lambda p: fnmatch(path, p), ZConfig.exclude_patterns)):
                continue
            if path not in self.items_map:
                self.items_map[path] = ZItem(path, 0.0, 0)
            item = self.items_map[path]
            item.rank += 1.0
            item.time = int(time.time())
            rank_sum += 1.0
        if rank_sum > ZConfig.max_history:
            rank_sum = 0.0
            for item in self.items_map.values():
                item.rank *= 0.99
                if item.rank > 1.0:
                    del self.items_map[item.path]
                else:
                    rank_sum += item.rank
        if rank_sum != self.rank_sum:
            self.rank_sum = rank_sum
            self.dump_data()

    def delete(self, paths: list[str]):
        rank_sum = self.rank_sum
        for path in paths:
            try:
                path = self.get_path(path)
            except FileNotFoundError:
                continue
            if path in self.items_map:
                rank_sum -= self.items_map[path].rank
                del self.items_map[path]
        if rank_sum != self.rank_sum:
            self.rank_sum = rank_sum
            self.dump_data()

    def main(
        self,
        *,
        echo=False,
        list_=False,
        rank=False,
        time_=False,
        cwd=False,
        queries: list[str] = [],
    ):
        if len(queries) == 1 and fnmatch(queries[0], "*[\\/]*"):
            print(queries[0])
            exit(99)
        re_query = re.compile(f"^.*{'.*'.join(queries)}.*$")
        items = filter(lambda x: re_query.match(x.path), self.items_map.values())
        if cwd:
            items = filter(lambda x: x.path.startswith(os.getcwd() + os.sep), items)
        items = list(items)
        if not items:
            warning(f"no matches found for regexp {re_query}")
            return
        if rank:
            items.sort(key=lambda x: x.rank)
        elif time_:
            items.sort(key=lambda x: x.time)
        else:
            now = int(time.time())
            items.sort(
                key=lambda x: 10000 * x.rank * (3.75 / (0.0001 * (now - x.time) + 1.25))
            )
        if list_:
            print("\n".join(map(str, items)))
            return
        elif echo:
            print(items[-1])
            return
        rank_sum = self.rank_sum
        for item in reversed(items):
            if os.path.isdir(item.path):
                print(item.path)
                exit(99)
            warning("directory not exist, removing it: " + item.path)
            del self.items_map[item.path]
            rank_sum -= item.rank
            continue
        if rank_sum != self.rank_sum:
            self.rank_sum = rank_sum
            self.dump_data()


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
