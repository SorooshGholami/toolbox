#!/usr/bin/env python3
"""
Rewrites the <filename> and <path> tags (lines 3 and 4) of every .xml file
in a folder — useful for fixing annotation files (e.g. Pascal VOC/LabelImg
XML) after moving or renaming the matching images.

(Renamed from Edit_Files_While_reading.py — the original hardcoded a
personal absolute path. Now takes the folder and the target image path
prefix as arguments.)

Usage:
    ./batch_update_xml_paths.py <xml_folder> <new_image_dir_path>

Example:
    ./batch_update_xml_paths.py ./annotations /data/dataset/images
"""

import sys
from pathlib import Path


def update_xml_file(xml_path: Path, new_image_dir: str) -> None:
    new_filename = xml_path.stem + ".png"
    new_full_path = f"{new_image_dir.rstrip('/')}/{new_filename}"

    with open(xml_path, "r") as f:
        lines = f.readlines()

    if len(lines) < 4:
        print(f"Skipping {xml_path.name}: fewer than 4 lines.")
        return

    lines[2] = f"\t<filename>{new_filename}</filename>\n"
    lines[3] = f"\t<path>{new_full_path}</path>\n"

    with open(xml_path, "w") as f:
        f.writelines(lines)


def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <xml_folder> <new_image_dir_path>")
        sys.exit(1)

    xml_folder = Path(sys.argv[1])
    new_image_dir = sys.argv[2]

    if not xml_folder.is_dir():
        print(f"Not a directory: {xml_folder}")
        sys.exit(1)

    for xml_file in xml_folder.glob("*.xml"):
        update_xml_file(xml_file, new_image_dir)
        print(f"Updated: {xml_file.name}")


if __name__ == "__main__":
    main()
