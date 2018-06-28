import os
import sys
from pathlib import Path
import click
import subprocess
import platform

skip = ["AtomicKotlin", "AtomicKotlin-Edu", "OnJava8-Examples-master", "PracticeJava", "IntuitiveJava.github.io",
        ".idea", ".git"]

if 'GIT_HOME' not in os.environ:
    print("You need to set 'GIT_HOME' as an environment variable")
    sys.exit(1)


def git_command(cmd, trace=False, skip=[]):
    for gd in [x for x in Path(os.environ['GIT_HOME']).iterdir() if x.is_dir()]:
        if gd.name in skip:
            print(f"Skipping {gd.name}")
            continue
        os.chdir(gd)
        if trace:
            print(f"{Path.cwd().name}")
        print(".", end="", flush=True)
        result = subprocess.check_output("git " + cmd, shell=True).decode('ascii')
        if "Already up-to-date" in result:
            continue
        if result:
            print(f"\n{'-'*10} [{gd.name}] {'-'*10}\n{result}")


@click.group()
def cli():
    """Git-all
    Performs various commands on all repositories in your local directory
    """


@cli.command()
def pull():
    "Pull on all repos"
    git_command("pull", skip=skip)


@cli.command()
def status():
    "Get status of all repos"
    git_command("status -s", skip=skip)
    print()
    print("".center(25, "="))
    print("  Un-Pushed  ".center(25, '='))
    print("".center(25, "="))
    git_command("log origin/master..HEAD", skip=skip)


repo_file = Path(__file__).parent / (platform.node() + "_repos.txt")


def create_repo_file():
    "Produce urls of all repos on this machine"
    urls = []
    for gd in [x for x in Path(os.environ['GIT_HOME']).iterdir() if x.is_dir()]:
        config = gd / ".git" / "config"
        result = "No url found"
        for line in [ln.strip() for ln in config.read_text().splitlines()]:
            if line.startswith("url ="):
                result = line.split()[-1]
        urls.append(result)
    repo_file.write_text("\n".join(sorted(urls)) + "\n")


@cli.command()
def repo_list():
    "Store urls of all repos on this machine"
    create_repo_file()
    print(f"{repo_file}")
    os.system(f"cat {repo_file}")


@cli.command()
def compare_repos():
    "Show what's on other machines that aren't on this one"
    if not repo_file.exists():
        create_repo_file()
    others = [f for f in Path(__file__).parent.glob("*_repos.txt") if f != repo_file]
    local_repos = set(repo_file.read_text().splitlines())
    for rf in others:
        other_repos = set(rf.read_text().splitlines())
        diff = other_repos - local_repos
        if diff:
            diffs = '\n'.join(diff)
            other_name = str(rf.name)[:len("_repos.txt")]
            print(f"{other_name} contains the following, which are not on this machine:\n{diffs}\n")


if __name__ == '__main__':
    cli()