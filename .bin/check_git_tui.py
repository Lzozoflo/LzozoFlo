import shutil
import subprocess
import sys
from pathlib import Path
from rich.markup import escape
from rich.text import Text
from textual import events, work
from textual.app import App, ComposeResult
from textual.containers import Horizontal, Vertical
from textual.widgets import (
    Button, Footer, Header, Input, Label, ListItem, ListView, OptionList, RichLog, Select
)

ROOT_REPO = Path.home() / "Project"
PREFIXES = [
    (escape("[fix]"), "[fix]"),
    (escape("[feat]"), "[feat]"),
    (escape("[refactor]"), "[refactor]"),
    (escape("[docs]"), "[docs]"),
    (escape("[chore]"), "[chore]"),
    (escape("[test]"), "[test]"),
    ("(aucun)", ""),
]


class FileItem(ListItem):
    def __init__(self, label: str, filepath: str) -> None:
        super().__init__(Label(Text(label, no_wrap=True)))
        self.filepath = filepath


def get_active_submodules() -> list[str]:
    gitmodules = ROOT_REPO / ".gitmodules"
    if not gitmodules.exists():
        return []

    res = subprocess.run(
        ["git", "config", "--file", str(gitmodules), "--get-regexp", "path"],
        capture_output=True, text=True
    )
    active = []
    for line in res.stdout.splitlines():
        path = line.split()[1]
        target = ROOT_REPO / path
        if (target / ".git").exists():
            dirty = subprocess.run(
                ["git", "-C", str(target), "status", "--porcelain"],
                capture_output=True, text=True
            ).stdout.strip()
            ahead = subprocess.run(
                ["git", "-C", str(target), "rev-list", "--count", "@{u}..HEAD"],
                capture_output=True, text=True
            )
            has_unpushed = ahead.returncode == 0 and ahead.stdout.strip() not in ("", "0")
            if dirty or has_unpushed:
                active.append(path)
    return active


def get_repo_files(repo: str) -> list[tuple[str, str]]:
    target = str(ROOT_REPO / repo)
    res = subprocess.run(
        ["git", "-c", "core.quotepath=false", "-C", target, "status", "--porcelain"],
        capture_output=True, text=True
    )
    files = []
    for line in res.stdout.splitlines():
        if len(line) > 3:
            status = line[:2]
            filepath = line[3:].split(" -> ")[-1].strip('"')
            files.append((f"{status} {filepath}", filepath))
    return files


class GitCheckTUI(App):
    CSS = """
    #main { height: 1fr; }
    #left { width: 40%; height: 1fr; }
    #repos { height: 1fr; border: solid green; }
    #files { height: 1fr; border: solid yellow; overflow-x: auto; }
    #files ListItem { width: auto; min-width: 100%; padding: 0 1; }
    #files ListItem Label { width: auto; }
    #files ListItem.selected { background: #1e6b34; color: #ffffff; text-style: bold; }
    #files ListItem.selected.-highlight { background: #288a44; }
    #preview { width: 60%; border: solid cyan; }
    #bar { height: auto; margin-top: 1; }
    #prefix { width: 20; margin-right: 1; }
    #msg { width: 1fr; margin-right: 1; }
    Button { margin-right: 1; }
    """
    BINDINGS = [
        ("a", "toggle_files", "Tout sélectionner/désélectionner"),
        ("r", "refresh", "Rafraîchir"),
        ("q", "quit", "Quitter"),
    ]

    def compose(self) -> ComposeResult:
        yield Header()
        with Horizontal(id="main"):
            with Vertical(id="left"):
                yield OptionList(id="repos")
                yield ListView(id="files")
            yield RichLog(id="preview", markup=True, highlight=True)
        with Horizontal(id="bar"):
            yield Select(PREFIXES, value="[fix]", allow_blank=False, id="prefix")
            yield Input(placeholder="Message de commit...", id="msg")
            yield Button("Commit", variant="success", id="commit_btn")
            yield Button("Push", variant="primary", id="push_btn")
        yield Footer()

    def on_mount(self) -> None:
        self.repos: list[str] = []
        self.current_repo: str | None = None
        self.current_files: list[tuple[str, str]] = []
        self.selected_files: set[str] = set()
        self.action_refresh()

    def action_refresh(self) -> None:
        ol = self.query_one("#repos", OptionList)
        fl = self.query_one("#files", ListView)
        preview = self.query_one("#preview", RichLog)

        prev_repo = self.current_repo
        ol.clear_options()
        fl.clear()
        preview.clear()

        self.repos = get_active_submodules()
        if not self.repos:
            self.current_repo = None
            self.current_files = []
            self.selected_files.clear()
            preview.write("[bold green]Tous les sous-modules sont propres et à jour.[/bold green]")
            return

        for repo in self.repos:
            ol.add_option(repo)

        idx = self.repos.index(prev_repo) if prev_repo in self.repos else 0
        ol.highlighted = idx
        self.load_repo(self.repos[idx])
        ol.focus()

    def on_option_list_option_highlighted(self, event: OptionList.OptionHighlighted) -> None:
        if event.option_list.id == "repos" and 0 <= event.option_index < len(self.repos):
            self.load_repo(self.repos[event.option_index])

    def on_list_view_selected(self, event: ListView.Selected) -> None:
        if event.list_view.id == "files" and isinstance(event.item, FileItem):
            self.toggle_file_item(event.item)

    def on_key(self, event: events.Key) -> None:
        fl = self.query_one("#files", ListView)
        if not fl.has_focus:
            return
        if event.key == "space" and isinstance(fl.highlighted_child, FileItem):
            self.toggle_file_item(fl.highlighted_child)
            event.stop()
        elif event.key == "right":
            fl.scroll_right()
            event.stop()
        elif event.key == "left":
            fl.scroll_left()
            event.stop()

    def toggle_file_item(self, item: FileItem) -> None:
        if item.filepath in self.selected_files:
            self.selected_files.remove(item.filepath)
            item.remove_class("selected")
        else:
            self.selected_files.add(item.filepath)
            item.add_class("selected")

    def load_repo(self, repo: str) -> None:
        self.current_repo = repo
        self.selected_files.clear()
        fl = self.query_one("#files", ListView)
        preview = self.query_one("#preview", RichLog)
        fl.clear()
        preview.clear()

        self.current_files = get_repo_files(repo)
        for label, path in self.current_files:
            fl.append(FileItem(label, path))

        target = str(ROOT_REPO / repo)
        ahead = subprocess.run(
            ["git", "-C", target, "log", "@{u}..HEAD", "--oneline"],
            capture_output=True, text=True
        ).stdout.strip()
        diff = subprocess.run(
            ["git", "-C", target, "diff", "--stat"],
            capture_output=True, text=True
        ).stdout.strip()

        preview.write(f"[bold cyan]=== {escape(repo)} ===[/bold cyan]\n")
        if ahead:
            preview.write("[bold magenta]Commits à pousser :[/bold magenta]")
            preview.write(escape(ahead) + "\n")
        if diff:
            preview.write("[bold yellow]Diff :[/bold yellow]")
            preview.write(escape(diff))
        elif not ahead:
            preview.write("[dim]Fichiers non suivis ou indexés uniquement.[/dim]")

    def action_toggle_files(self) -> None:
        fl = self.query_one("#files", ListView)
        items = list(fl.query(FileItem))
        all_paths = {item.filepath for item in items}
        select_all = self.selected_files != all_paths
        self.selected_files = all_paths if select_all else set()
        for item in items:
            item.set_class(select_all, "selected")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if not self.current_repo:
            return
        if event.button.id == "commit_btn":
            files = [p for _, p in self.current_files if p in self.selected_files]
            prefix = self.query_one("#prefix", Select).value
            msg = self.query_one("#msg", Input).value.strip()
            if not files:
                self.notify("Sélectionne au moins un fichier.", severity="warning")
                return
            if not msg:
                self.notify("Entre un message de commit.", severity="warning")
                return
            full_msg = f"{prefix} {msg}".strip()
            self.run_commit(self.current_repo, files, full_msg)
        elif event.button.id == "push_btn":
            self.run_push(self.current_repo)

    @work(exclusive=True, thread=True)
    def run_commit(self, repo: str, files: list[str], msg: str) -> None:
        target = str(ROOT_REPO / repo)
        subprocess.run(["git", "-C", target, "add", "--", *files], check=False)
        res = subprocess.run(["git", "-C", target, "commit", "-m", msg], capture_output=True, text=True)
        if res.returncode == 0:
            self.call_from_thread(self.notify, f"✓ Commit créé : {msg}", severity="information")
            self.call_from_thread(self.clear_msg_and_refresh)
        else:
            self.call_from_thread(self.notify, f"✗ Erreur commit : {res.stderr.strip()}", severity="error")

    def clear_msg_and_refresh(self) -> None:
        self.query_one("#msg", Input).value = ""
        self.action_refresh()

    @work(exclusive=True, thread=True)
    def run_push(self, repo: str) -> None:
        target = str(ROOT_REPO / repo)
        self.call_from_thread(self.notify, f"Push de {repo}...")
        res = subprocess.run(["git", "-C", target, "push"], capture_output=True, text=True)
        if res.returncode == 0:
            self.call_from_thread(self.notify, f"✓ {repo} poussé", severity="information")
            self.call_from_thread(self.action_refresh)
        else:
            self.call_from_thread(self.notify, f"✗ Erreur push : {res.stderr.strip()}", severity="error")

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


if __name__ == "__main__":
    check_terminal_size()
    GitCheckTUI().run()