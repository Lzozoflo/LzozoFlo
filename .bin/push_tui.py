import subprocess
from pathlib import Path
from textual import work
from textual.app import App, ComposeResult
from textual.widgets import Button, Footer, Header, Input, RichLog, SelectionList

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


class GitPushTUI(App):
    CSS = """
    SelectionList { height: 1fr; border: solid green; }
    Input { margin: 1 0; }
    RichLog { height: 10; border: solid cyan; }
    """
    BINDINGS = [("q", "quit", "Quitter"), ("r", "refresh", "Rafraîchir")]

    def compose(self) -> ComposeResult:
        yield Header()
        yield SelectionList(id="repos")
        yield Input(placeholder="Message de commit (laisser vide pour git push seul)", id="msg")
        yield Button("Push la sélection", variant="primary", id="push_btn")
        yield RichLog(id="log", highlight=True)
        yield Footer()

    def on_mount(self) -> None:
        self.action_refresh()

    def action_refresh(self) -> None:
        sel = self.query_one("#repos", SelectionList)
        log = self.query_one("#log", RichLog)
        sel.clear_options()
        dirty = get_dirty_submodules()
        if not dirty:
            log.write("[green]Aucun sous-module modifié.[/green]")
            return
        for repo in dirty:
            sel.add_option((repo, repo, True))  # Pré-sélectionné
        log.write(f"[cyan]{len(dirty)} sous-module(s) modifié(s) détecté(s).[/cyan]")

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "push_btn":
            repos = self.query_one("#repos", SelectionList).selected
            msg = self.query_one("#msg", Input).value.strip()
            if repos:
                self.run_push(list(repos), msg)

    @work(exclusive=True, thread=True)
    def run_push(self, repos: list[str], msg: str) -> None:
        log = self.query_one("#log", RichLog)
        for repo in repos:
            target = ROOT_REPO / repo
            self.call_from_thread(log.write, f"[yellow]Push de {repo}...[/yellow]")
            if msg:
                subprocess.run(["git", "-C", str(target), "add", "-A"], check=False)
                subprocess.run(["git", "-C", str(target), "commit", "-m", msg], check=False)
            res = subprocess.run(
                ["git", "-C", str(target), "push"],
                capture_output=True, text=True
            )
            if res.returncode == 0:
                self.call_from_thread(log.write, f"[green]✓ {repo} poussé.[/green]")
            else:
                self.call_from_thread(log.write, f"[red]✗ Erreur {repo} : {res.stderr.strip()}[/red]")
        self.call_from_thread(self.action_refresh)


if __name__ == "__main__":
    GitPushTUI().run()