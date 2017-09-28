@echo off& python -x %0".bat" %* &goto :eof
from pathlib import Path
import sys, os

paths = [Path(p) for p in os.getenv('PATH').split(";")]
[print(p) for p in paths]
nonexistent = [p for p in paths if not p.exists()]
if nonexistent:
    print("\nDoesn't exist:")
    [print(f"\t{p}") for p in nonexistent]
