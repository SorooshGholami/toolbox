#!/usr/bin/env python3
"""
Small helper class for ANSI terminal colors/styles.

Note: the original version mislabeled several codes (e.g. "cyan" pointed
at code 93, which is actually bright yellow). Labels below match the
standard ANSI bright-color codes.
"""


class bcolors:
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    GREEN_BG = '\033[01;43m'
    PINK_BG = '\033[01;41m'
    PURPLE_BG = '\033[01;42m'


if __name__ == "__main__":
    print(bcolors.BOLD + bcolors.CYAN + "Terminal color helper loaded." + bcolors.ENDC)
