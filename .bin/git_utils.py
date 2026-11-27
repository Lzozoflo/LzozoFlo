import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT_REPO = Path.home() / "Project"
MIN_COLS = 80
MIN_LINES = 24


def check_terminal_size() -> None:
    size = shutil.get_terminal_size()
    if size.columns < MIN_COLS or size.lines < MIN_LINES:
        print(
            f"Erreur : terminal trop petit ({size.columns}x{size.lines}).\n"
            f"Taille minimale requise : {MIN_COLS}x{MIN_LINES}.",
            file=sys.stderr,
        )
        sys.exit(1)


def get_submodules() -> list[tuple[str, str, bool]]:
    gitmodules = ROOT_REPO / ".gitmodules"
    if not gitmodules.exists():
        return []

    paths_res = subprocess.run(
        ["git", "config", "--file", str(gitmodules), "--get-regexp", r"^submodule\..*\.path$"],
        capture_output=True, text=True
    )
    urls_res = subprocess.run(
        ["git", "config", "--file", str(gitmodules), "--get-regexp", r"^submodule\..*\.url$"],
        capture_output=True, text=True
    )

    urls: dict[str, str] = {}
    for line in urls_res.stdout.splitlines():
        parts = line.split(maxsplit=1)
        if len(parts) == 2:
            name = parts[0].removeprefix("submodule.").removesuffix(".url")
            urls[name] = parts[1].strip()

    submodules: list[tuple[str, str, bool]] = []
    for line in paths_res.stdout.splitlines():
        parts = line.split(maxsplit=1)
        if len(parts) == 2:
            name = parts[0].removeprefix("submodule.").removesuffix(".path")
            path = parts[1].strip()
            url = urls.get(name, "")
            installed = (ROOT_REPO / path / ".git").exists()
            submodules.append((path, url, installed))

    return submodules


def get_branches(path: str, url: str, installed: bool) -> list[str]:
    if installed:
        target = str(ROOT_REPO / path)
        res = subprocess.run(
            ["git", "-C", target, "branch", "-a", "--format=%(refname:short)"],
            capture_output=True, text=True
        )
        branches = {
            b.removeprefix("origin/").strip()
            for b in res.stdout.splitlines()
            if b.strip() and "HEAD" not in b
        }
        return sorted(branches)

    res = subprocess.run(
        ["git", "ls-remote", "--heads", url],
        capture_output=True, text=True
    )
    branches = set()
    for line in res.stdout.splitlines():
        parts = line.split()
        if len(parts) == 2 and parts[1].startswith("refs/heads/"):
            branches.add(parts[1].removeprefix("refs/heads/"))
    return sorted(branches)