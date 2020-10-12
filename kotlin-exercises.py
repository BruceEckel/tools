import subprocess
from pathlib import Path

# Once complete, capitalize IDEA everywhere

edit_boundary = 1602369729.1761289  # Oct 10, 2020

exercises_dir = Path("c:/", "Git", "AtomicKotlinCourse")

tasks = list(exercises_dir.rglob("task.md"))

if __name__ == '__main__':
    for task in tasks:
        if 'Examples' in task.parts:
            continue
        # if task.stat().st_mtime > edit_boundary:
        #     continue
        text = task.read_text()
        if "idea" in text or "Idea" in text:
            subprocess.call(['subl.exe', f"{task}"])
