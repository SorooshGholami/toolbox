#!/usr/bin/env python3
"""
For every .png file in a source folder, copies a template file to a
destination folder under a matching name (.png -> .xml). Useful for
bootstrapping placeholder annotation files for a batch of images.

(Renamed from Multiple_Copy.py — the original hardcoded a personal
absolute path and a specific source filename. Now takes all three paths
as arguments.)

Usage:
    ./batch_copy_files.py <source_png_folder> <template_xml_file> <destination_folder>

Example:
    ./batch_copy_files.py ./images ./labels/template.xml ./labels/test
"""

import shutil
import sys
from pathlib import Path


def main():
    if len(sys.argv) != 4:
        print(f"Usage: {sys.argv[0]} <source_png_folder> <template_xml_file> <destination_folder>")
        sys.exit(1)

    source_folder = Path(sys.argv[1])
    template_file = Path(sys.argv[2])
    dest_folder = Path(sys.argv[3])

    if not source_folder.is_dir():
        print(f"Not a directory: {source_folder}")
        sys.exit(1)
    if not template_file.is_file():
        print(f"Template file not found: {template_file}")
        sys.exit(1)

    dest_folder.mkdir(parents=True, exist_ok=True)

    count = 0
    for file in source_folder.glob("*.png"):
        dest_name = file.stem + ".xml"
        shutil.copy(template_file, dest_folder / dest_name)
        count += 1

    print(f"Copied template to {count} destination file(s) in {dest_folder}")


if __name__ == "__main__":
    main()
