import subprocess
from pathlib import Path
from rich.markup import escape
from textual import work
from textual.app import App, ComposeResult
from textual.containers import Horizontal
from textual.widgets import Button, Footer, Header, Input, OptionList, RichLog

ROOT_REPO = Path.home() / "Project"


def get_dirty_submodules() -> list[str]:
    gitmodules = ROOT_REPO / ".gitmodules"
    if not gitmodules.exists():
        return []

    res = subprocess.run(
        ["git", "config", "--file", str(gitmodules), "--get-regexp", "path"],
        capture_output=True, text=True
    )
    dirty = []
    for line in res.stdout.splitlines():
        path = line.split()[1]
        target = ROOT_REPO / path
        if (target / ".git").exists():
            status = subprocess.run(
                ["git", "-C", str(target), "status", "--porcelain"],
                capture_output=True, text=True
            )
            if status.stdout.strip():
                dirty.append(path)
    return dirty


class GitCheckTUI(App):
    CSS = """
    #main { height: 1fr; }
    OptionList { width: 35%; border: solid green; }
    RichLog { width: 65%; border: solid cyan; }
    #bar { height: auto; margin-top: 1; }
    Input { width: 1fr; margin-right: 1; }
    """
    BINDINGS = [
        ("p", "push_selected", "Push ce dépôt"),
        ("r", "refresh", "Rafraîchir"),
        ("q", "quit", "Quitter"),
    ]

    def compose(self) -> ComposeResult:
        yield Header()
        with Horizontal(id="main"):
            yield OptionList(id="repos")
            yield RichLog(id="preview", markup=True, highlight=True)
        with Horizontal(id="bar"):
            yield Input(placeholder="Message de commit (optionnel)", id="msg")
            yield Button("Push", variant="primary", id="push_btn")
        yield Footer()

    def on_mount(self) -> None:
        self.dirty_repos: list[str] = []
        self.action_refresh()

    def action_refresh(self) -> None:
        ol = self.query_one("#repos", OptionList)
        preview = self.query_one("#preview", RichLog)
        ol.clear_options()
        preview.clear()

        self.dirty_repos = get_dirty_submodules()
        if not self.dirty_repos:
            preview.write("[bold green]Tous les sous-modules sont propres.[/bold green]")
            return

        for repo in self.dirty_repos:
            ol.add_option(repo)
        ol.focus()
        ol.highlighted = 0
        self.show_preview(self.dirty_repos[0])

    def on_option_list_option_highlighted(self, event: OptionList.OptionHighlighted) -> None:
        if 0 <= event.option_index < len(self.dirty_repos):
            self.show_preview(self.dirty_repos[event.option_index])

    def show_preview(self, repo: str) -> None:
        preview = self.query_one("#preview", RichLog)
        preview.clear()
        target = str(ROOT_REPO / repo)

        status = subprocess.run(["git", "-C", target, "status", "--short"], capture_output=True, text=True).stdout
        diff = subprocess.run(["git", "-C", target, "diff", "--stat"], capture_output=True, text=True).stdout

        preview.write(f"[bold cyan]=== {escape(repo)} ===[/bold cyan]\n")
        preview.write("[bold yellow]Status :[/bold yellow]")
        preview.write(escape(status.strip()) or "[dim]Aucun changement non indexé[/dim]")
        if diff.strip():
            preview.write("\n[bold yellow]Diff :[/bold yellow]")
            preview.write(escape(diff.strip()))

    def action_push_selected(self) -> None:
        ol = self.query_one("#repos", OptionList)
        if ol.highlighted is None or not self.dirty_repos:
            return
        repo = self.dirty_repos[ol.highlighted]
        msg = self.query_one("#msg", Input).value.strip()
        self.run_push(repo, msg)

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "push_btn":
            self.action_push_selected()

    @work(exclusive=True, thread=True)
    def run_push(self, repo: str, msg: str) -> None:
        target = str(ROOT_REPO / repo)
        self.call_from_thread(self.notify, f"Push de {repo} en cours...")
        if msg:
            subprocess.run(["git", "-C", target, "add", "-A"], check=False)
            subprocess.run(["git", "-C", target, "commit", "-m", msg], check=False)
        res = subprocess.run(["git", "-C", target, "push"], capture_output=True, text=True)

        if res.returncode == 0:
            self.call_from_thread(self.notify, f"✓ {repo} poussé", severity="information")
            self.call_from_thread(self.action_refresh)
        else:
            self.call_from_thread(self.notify, f"✗ Erreur : {res.stderr.strip()}", severity="error")


if __name__ == "__main__":
    GitCheckTUI().run()