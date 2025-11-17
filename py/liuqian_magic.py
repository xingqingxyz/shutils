import random
import sys

DEBUG = "--debug" in sys.argv


def debug(*args, **kwargs):
    if DEBUG:
        print(*args, **kwargs)


def proxy(n):
    return 1 < n < 11 and n or {1: "A", 11: "J", 12: "Q", 13: "K"}[n]


def get_random_cards():
    cards = set()
    while len(cards) < 4:
        color = random.choice(["spade", "club", "heart", "diamond"])
        order = proxy(random.randint(1, 13))
        cards.add(f"{color}_{order}")

    cards = list(cards)
    debug(cards)
    return cards


def cut_cards(cards):
    if random.random() < 0.5:
        deck = "up"
        outer = "down"
    else:
        deck = "down"
        outer = "up"
    for i in range(len(cards)):
        cards.append(f"{cards[i]}_{outer}")
        cards[i] = f"{cards[i]}_{deck}"
    debug(cards)
    return cards


def choice_insert(cards, cnt):
    rand_idx = random.randint(cnt + 1, len(cards) - 2)
    cards[rand_idx:rand_idx] = cards[:cnt]
    del cards[:cnt]
    debug(cards)


def move(cards):
    cards.append(cards[0])
    del cards[0]
    debug(cards)


def liuqian_magic(inputs):
    # 0->n: up->down
    cards = cut_cards(get_random_cards())
    # m1
    inputs["name_len"] %= len(cards)
    cards += cards[: inputs["name_len"]]
    del cards[: inputs["name_len"]]
    debug(cards)
    # m2
    choice_insert(cards, 3)
    # d1
    actual = cards[0].rsplit("_", 1)[0]
    del cards[0]
    debug(cards)
    # m3
    choice_insert(cards, inputs["region"])
    # d2
    del cards[: inputs["sex"]]
    debug(cards)
    # j z q j d s k -> cnt: 7
    for _ in range(7 % len(cards)):
        move(cards)
    lucky = True
    while len(cards) != 1:
        if lucky:
            move(cards)
        else:
            del cards[0]
            debug(cards)
        lucky = not lucky
    expected = cards[0].rsplit("_", 1)[0]
    debug(expected, actual)
    return expected == actual


def main():
    inputs = {
        "sex": random.randint(1, 2),
        "region": random.randint(1, 3),
        "name_len": random.randint(2, 1000),
    }
    debug(inputs)
    assert liuqian_magic(inputs)


if __name__ == "__main__":
    times = DEBUG and 3 or 100000
    for _ in range(times):
        main()
