import re
import sys
from pathlib import Path

import backtrace
import click

backtrace.hook(
    reverse=False,
    align=False,
    strip_path=False,
    enable_on_envvar_only=False,
    on_tty=False,
    conservative=False,
    styles={},
)

gitPath = Path.cwd().parent
markdown_dir = gitPath / "EOPBook" / "Chapters"


def exists(path):
    if not path.exists():
        print(f"Error: {path} does not exist")
        sys.exit()


@click.group()
@click.version_option()
def cli():
    """
    Additional tools for Effect-Oriented Programming
    """


@cli.command()
@click.argument('filename')
def insert_chapter(filename):
    """Insert numbered chapter and renumber higher chapters"""
    exists(markdown_dir)
    click.echo(f"found {markdown_dir}")
    numbered_chapter = re.compile("^(\d{2})_(.+\.md)")
    assert numbered_chapter.match(filename), f"{filename} does not match numbered chapter pattern"
    click.echo(f" OK: {filename}")

    numbered = [md.name for md in markdown_dir.glob("*.md") if numbered_chapter.match(md.name)]
    pairs = [numbered_chapter.findall(chapter)[0] for chapter in numbered]
    pair = numbered_chapter.findall(filename)
    chapnum = pair[0][0].strip()
    to_rename = [(p[0], f"{int(p[0]) + 1:02}", p[1]) for p in pairs if p[0] >= chapnum]
    for tr in to_rename:
        click.echo(tr)
        old = markdown_dir / f"{tr[0]}_{tr[2]}"
        new = markdown_dir / f"{tr[1]}_{tr[2]}"
        click.echo(f"Old: {old}")
        click.echo(f"New: {new}")
        old.rename(new)
        inserted_chapter = markdown_dir / filename
        inserted_chapter.write_text("")


if __name__ == "__main__":
    cli()
