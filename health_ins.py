from pathlib import Path

checking = Path("Personal2021.csv")
print(checking.exists())
print(checking.is_file())
anthem = [line for line in checking.read_text().splitlines() if "ANTHEM BLUE" in line]
Path("Anthem2021.csv").write_text("\n".join(sorted(anthem)))

