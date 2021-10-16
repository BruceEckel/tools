import pprint
import subprocess
import sys, os
from pathlib import Path

jdk_dir = Path("c:/", "Program Files", "Java")

java_jdks = list(jdk_dir.glob("*"))


def first_digits(number):
    result = ""
    for c in number:
        if c.isdigit():
            result += c
        else:
            return result
    return result


def get_number(jdkname):
    result = ''
    parts = jdkname.split("-")
    for p in parts:
        result += first_digits(p)
    return result


jdk_options = {get_number(path.name): path for path in java_jdks}
find_jdk = dict(map(reversed, jdk_options.items()))
option_msg = f"Options: {' '.join(jdk_options.keys())}"


def exists(*paths: Path):
    for path in paths:
        if not path.exists():
            print(f"{path} does not exist")
            sys.exit(1)


def set_jdk(number):
    jdk_path = jdk_options[number]
    jdk_bin = jdk_path / "bin"
    exists(jdk_path, jdk_bin)
    print(jdk_path)
    print(jdk_bin)
    subprocess.call(['setx.exe', 'JAVA_HOME', f"{jdk_path}"])
    subprocess.call(['setx.exe', 'PATH', f"{jdk_bin}"])


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(option_msg)
        java_home = Path(os.environ['JAVA_HOME'])
        print(f"Current JDK: {find_jdk[java_home]}")
    else:
        desired = sys.argv[1]
        if desired not in jdk_options.keys():
            print(f"Option {desired} not found.")
            print(option_msg)
            sys.exit(1)
        set_jdk(desired)
