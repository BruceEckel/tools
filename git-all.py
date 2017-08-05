import os
import sys
from pathlib import Path
import click
import subprocess
import platform


if 'GIT_HOME' not in os.environ:
    print("You need to set 'GIT_HOME' as an environment variable")
    sys.exit(1)


def git_command(cmd):
    for gd in [x for x in Path(os.environ['GIT_HOME']).iterdir() if x.is_dir()]:
        os.chdir(gd)
        result = subprocess.check_output("git " + cmd, shell=True).decode('ascii')
        if "Already up-to-date" in result:
            continue
        if result:
            print(f"{'-'*10} [{gd.name}] {'-'*10}\n{result}")


@click.group()
def cli():
    """Git-all
    Performs various commands on all repositories in your local directory
    """


@cli.command()
def pull():
    "Pull on all repos"
    git_command("pull")


@cli.command()
def status():
    "Get status of all repos"
    git_command("status -s")


@cli.command()
def all_urls():
    "Produce urls of all repos on this machine"
    urls = []
    for gd in [x for x in Path(os.environ['GIT_HOME']).iterdir() if x.is_dir()]:
        config = gd / ".git" / "config"
        result = "No url found"
        for line in [ln.strip() for ln in config.read_text().splitlines()]:
            if line.startswith("url ="):
                result = line.split()[-1]
        urls.append(result)
    repo_list = Path(__file__).parent / (platform.node() + "_repos.txt")
    repo_list.write_text("\n".join(sorted(urls)) + "\n")
    os.system(f"cat {repo_list}")


if __name__ == '__main__':
    cli()
