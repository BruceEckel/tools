import pprint
import sys
from pathlib import Path
import subprocess


exercises_dir = Path("c:/", "Git", "AtomicKotlinCourse")

tasks = list(exercises_dir.rglob("task.md"))


def exists(*paths: Path):
    for path in paths:
        if not path.exists():
            print(f"{path} does not exist")
            sys.exit(1)


if __name__ == '__main__':
    for task in tasks:
        if 'Examples' in task.parts:
            continue
        subprocess.call(['subl.exe', f"{task}"])
