from rich.markup import escape
from textual import work
from textual.app import App, ComposeResult
from textual.containers import Horizontal, Vertical
from textual.widgets import Button, Footer, Header, Input, Label, OptionList

from git_utils import (
    ROOT_REPO,
    check_terminal_size,
    get_branches,
    get_submodules,
    subprocess,
    tempfile,
)


class SubmoduleTUI(App):
    CSS = """
    #top_panes { height: 1fr; }
    .pane_col { width: 1fr; height: 1fr; }
    .pane_title { text-style: bold; padding-left: 1; }
    #installed_list { height: 1fr; border: solid green; }
    #branches { height: 1fr; border: solid magenta; }
    #uninstalled_list { height: 1fr; border: solid yellow; }

    .arrow_col { width: auto; height: 1fr; align: center middle; padding: 0 1; }
    .arrow_col Button { min-width: 5; }

    #switch_bar { height: auto; align: center middle; margin: 1 0; }
    #switch_btn { min-width: 24; }

    #add_bar { height: auto; }
    #url_input, #path_input { width: 1fr; margin-right: 1; }
    """

    BINDINGS = [
        ("r", "refresh", "Rafraîchir"),
        ("q", "quit", "Quitter"),
    ]

    def compose(self) -> ComposeResult:
        yield Header()

        with Horizontal(id="top_panes"):
            with Vertical(classes="pane_col"):
                yield Label("Installés", classes="pane_title")
                yield OptionList(id="installed_list")
            with Vertical(classes="arrow_col"):
                yield Button("<", variant="success", id="install_btn")
            with Vertical(classes="pane_col"):
                yield Label("Branches", classes="pane_title")
                yield OptionList(id="branches")
            with Vertical(classes="arrow_col"):
                yield Button(">", variant="warning", id="deinit_btn")
            with Vertical(classes="pane_col"):
                yield Label("Non installés", classes="pane_title")
                yield OptionList(id="uninstalled_list")

        with Horizontal(id="switch_bar"):
            yield Button("Switch", variant="primary", id="switch_btn")

        with Horizontal(id="add_bar"):
            yield Input(placeholder="URL du dépôt...", id="url_input")
            yield Input(placeholder="Emplacement...", id="path_input")
            yield Button("Créer / Init / Ajouter", variant="primary", id="add_btn")

        yield Footer()

    def on_mount(self) -> None:
        self.installed_subs: list[tuple[str, str, bool]] = []
        self.uninstalled_subs: list[tuple[str, str, bool]] = []
        self.current_sub: tuple[str, str, bool] | None = None
        self.branches: list[str] = []
        self.current_branch: str | None = None
        self.action_refresh()

    def action_refresh(self) -> None:
        inst_ol = self.query_one("#installed_list", OptionList)
        uninst_ol = self.query_one("#uninstalled_list", OptionList)
        bl = self.query_one("#branches", OptionList)

        prev_path = self.current_sub[0] if self.current_sub else None
        inst_ol.clear_options()
        uninst_ol.clear_options()
        bl.clear_options()

        all_subs = get_submodules()
        self.installed_subs = [s for s in all_subs if s[2]]
        self.uninstalled_subs = [s for s in all_subs if not s[2]]

        if not all_subs:
            self.current_sub = None
            self.branches = []
            self.current_branch = None
            self.notify("Aucun sous-module trouvé dans .gitmodules.", severity="warning")
            return

        for path, _, _ in self.installed_subs:
            inst_ol.add_option(escape(path))
        for path, _, _ in self.uninstalled_subs:
            uninst_ol.add_option(escape(path))

        inst_paths = [s[0] for s in self.installed_subs]
        uninst_paths = [s[0] for s in self.uninstalled_subs]

        if prev_path in inst_paths:
            idx = inst_paths.index(prev_path)
            inst_ol.highlighted = idx
            self.load_submodule(self.installed_subs[idx])
            inst_ol.focus()
        elif prev_path in uninst_paths:
            idx = uninst_paths.index(prev_path)
            uninst_ol.highlighted = idx
            self.load_submodule(self.uninstalled_subs[idx])
            uninst_ol.focus()
        elif self.installed_subs:
            inst_ol.highlighted = 0
            self.load_submodule(self.installed_subs[0])
            inst_ol.focus()
        elif self.uninstalled_subs:
            uninst_ol.highlighted = 0
            self.load_submodule(self.uninstalled_subs[0])
            uninst_ol.focus()

    def on_option_list_option_highlighted(self, event: OptionList.OptionHighlighted) -> None:
        oid = event.option_list.id
        idx = event.option_index
        if oid == "installed_list" and 0 <= idx < len(self.installed_subs):
            self.load_submodule(self.installed_subs[idx])
        elif oid == "uninstalled_list" and 0 <= idx < len(self.uninstalled_subs):
            self.load_submodule(self.uninstalled_subs[idx])
        elif oid == "branches" and 0 <= idx < len(self.branches):
            self.current_branch = self.branches[idx]

    @work(exclusive=True, thread=True)
    def load_submodule(self, sub: tuple[str, str, bool]) -> None:
        path, url, installed = sub
        self.current_sub = sub
        self.call_from_thread(self._clear_branches)
        branches = get_branches(path, url, installed)
        self.call_from_thread(self._render_branches, branches)

    def _clear_branches(self) -> None:
        self.query_one("#branches", OptionList).clear_options()

    def _render_branches(self, branches: list[str]) -> None:
        bl = self.query_one("#branches", OptionList)
        self.branches = branches
        bl.clear_options()
        for b in branches:
            bl.add_option(escape(b))
        if branches:
            bl.highlighted = 0
            self.current_branch = branches[0]
        else:
            self.current_branch = None

    def on_button_pressed(self, event: Button.Pressed) -> None:
        btn = event.button.id
        if btn == "add_btn":
            url = self.query_one("#url_input", Input).value.strip()
            path = self.query_one("#path_input", Input).value.strip()
            if not url or not path:
                self.notify("Renseigne l'URL et l'emplacement.", severity="warning")
                return
            self.run_add(url, path)
            return

        if not self.current_sub:
            self.notify("Aucun sous-module sélectionné.", severity="warning")
            return

        path, _, installed = self.current_sub
        if btn == "install_btn":
            if installed:
                self.notify("Déjà installé.", severity="warning")
                return
            self.run_update(path, self.current_branch or "main")
        elif btn == "deinit_btn":
            if not installed:
                self.notify("Déjà non installé.", severity="warning")
                return
            self.run_deinit(path)
        elif btn == "switch_btn":
            if not self.current_branch:
                self.notify("Sélectionne une branche.", severity="warning")
                return
            self.run_update(path, self.current_branch)

    @work(exclusive=True, thread=True)
    def run_add(self, url: str, path: str) -> None:
        self.call_from_thread(self.notify, f"Ajout de {path}...")
        ls = subprocess.run(["git", "ls-remote", url], capture_output=True, text=True)
        if not ls.stdout.strip():
            self.call_from_thread(self.notify, "Dépôt vide : création du commit initial...")
            with tempfile.TemporaryDirectory() as tmp:
                subprocess.run(["git", "clone", url, tmp], check=False)
                subprocess.run(["git", "-C", tmp, "commit", "--allow-empty", "-m", "Initial commit"], check=False)
                subprocess.run(["git", "-C", tmp, "push", "-u", "origin", "main"], check=False)

        res = subprocess.run(
            ["git", "-C", str(ROOT_REPO), "submodule", "add", url, path],
            capture_output=True, text=True
        )
        if res.returncode == 0:
            self.call_from_thread(self.notify, f"✓ {path} ajouté.", severity="information")
            self.call_from_thread(self._clear_add_inputs)
            self.call_from_thread(self.action_refresh)
        else:
            self.call_from_thread(self.notify, f"✗ Erreur : {res.stderr.strip()}", severity="error")

    def _clear_add_inputs(self) -> None:
        self.query_one("#url_input", Input).value = ""
        self.query_one("#path_input", Input).value = ""

    @work(exclusive=True, thread=True)
    def run_update(self, path: str, branch: str) -> None:
        target = str(ROOT_REPO / path)
        self.call_from_thread(self.notify, f"Switch / Update {path} ({branch})...")
        subprocess.run(
            ["git", "-C", str(ROOT_REPO), "submodule", "update", "--init", "--remote", path],
            capture_output=True, text=True
        )
        subprocess.run(["git", "-C", target, "fetch", "--all"], capture_output=True, text=True)
        sw = subprocess.run(["git", "-C", target, "switch", branch], capture_output=True, text=True)
        pl = subprocess.run(["git", "-C", target, "pull"], capture_output=True, text=True)
        if sw.returncode == 0 and pl.returncode == 0:
            self.call_from_thread(self.notify, f"✓ {path} sur {branch}", severity="information")
            self.call_from_thread(self.action_refresh)
        else:
            err = (sw.stderr or pl.stderr).strip()
            self.call_from_thread(self.notify, f"✗ Erreur : {err}", severity="error")

    @work(exclusive=True, thread=True)
    def run_deinit(self, path: str) -> None:
        res = subprocess.run(
            ["git", "-C", str(ROOT_REPO), "submodule", "deinit", "-f", path],
            capture_output=True, text=True
        )
        if res.returncode == 0:
            self.call_from_thread(self.notify, f"✓ {path} décloné.", severity="information")
            self.call_from_thread(self.action_refresh)
        else:
            self.call_from_thread(self.notify, f"✗ Erreur : {res.stderr.strip()}", severity="error")


if __name__ == "__main__":
    check_terminal_size()
    SubmoduleTUI().run()