
# ─── Aliases ─────────────────────────────────────────────────────────────────

alias remote='git remote -v'
alias remote_add='git remote add'
alias p='push'
alias psuh='push'   # garde la faute de frappe pour la mémoire musculaire 😄

alias mergedev='mymerge "dev/frontend-hot-reload"'
alias pulldev='pullbranch "dev/frontend-hot-reload"'




# ─── Git : état ──────────────────────────────────────────────────────────────

_is_dirty() {
    [[ -n $(git status --porcelain) ]]
}


# ─── Git : push interne ───────────────────────────────────────────────────────

_push() {
    local target="$1"
    local no_status="${2:-}"

    ! _is_dirty && return 0

    # Subshell : le `cd` de find_first_of n'affecte pas le shell parent
    (
        find_first_of .git || exit 1

        if [[ "$no_status" != "--no-status" ]]; then
            print_status info "Vous êtes sûr de vouloir push tout ça ?"
            git status -s
            print_status info "Voulez-vous faire [add / commit / push] ? (y/n) : " -n
            _ask || exit 1
        fi

        local branch
        branch=$(git branch --show-current)


        git add .               || exit 1
        git commit -m "$target" || exit 1
        git push                || exit 1

        print_status success "Push sur '$branch' effectué !"
    )
}


# ─── Git : push interactif ────────────────────────────────────────────────────

push() {
    if [[ -n "$1" ]]; then
        _push "$1"
        return $?
    fi

    if ! _is_dirty; then
        print_status info "Repo propre — rien à pusher."
        return 0
    fi

    print_status info "Modifications détectées."

    find_first_of .git || return 1

    git status -s

    cd $OLDPWD

    print_status info "Voulez-vous faire [add / commit / push] ? (y/n) : " -n

    local choice
    read -r choice
    echo ""

    case "${choice:l}" in
        y)
            print_status info "Message de commit : " -n
            read -r choice
            _push "$choice" "--no-status"
            ;;
    esac
}

# ─── Git : pull + merge d'une branche distante vers la courante ───────────────

pullbranch() {

    if _is_dirty; then
        push || return 1
        echo ""
    fi

    local branch_actuel branch_a_update
    branch_actuel=$(git branch --show-current)
    branch_a_update="$1"

    echo ""
    print_status info "Pull de '$branch_a_update' vers '$branch_actuel'..."

    git pull origin "$branch_a_update" && git push || {
        print_status error "[pullbranch] Conflit ou erreur réseau — bonne chance 🫡"
        return 1
    }

    print_status success "Pull de '$branch_a_update' vers '$branch_actuel' terminé !"
}


# ─── Git : merge bidirectionnel ───────────────────────────────────────────────

mergebranch() {

    pullbranch "$1" || return $?

    local branch_actuel branch_a_update
    branch_actuel=$(git branch --show-current)
    branch_a_update="$1"

    echo ""
    print_status info "Merge de '$branch_actuel' vers '$branch_a_update'..."

    git switch "$branch_a_update" && git merge "$branch_actuel" && git push || {
        print_status error "[mergebranch] Conflit ou erreur — bonne chance 🫡"
        git switch "$branch_actuel" 2>/dev/null   # tente de revenir quand même
        return 1
    }

    git switch "$branch_actuel"

    print_status success "Merge de '$branch_actuel' vers '$branch_a_update' terminé !"
}


# ─── Git : workflow merge complet avec confirmation ───────────────────────────

mymerge() {
    if _is_dirty; then
        push || return 1
    fi

    local branch_actuel branch_a_update
    branch_actuel=$(git branch --show-current)
    branch_a_update="$1"

    if [[ -z "$branch_a_update" ]] || ! git show-ref --verify --quiet "refs/heads/$branch_a_update"; then
        print_status error "La branche '$branch_a_update' est invalide ou n'existe pas localement."
        return 1
    fi

    print_status info "─── RÉCAPITULATIF ───────────────────────"
    print_status info "Branche courante        : '$branch_actuel'"
    print_status info "Branche cible du merge  : '$branch_a_update'"
    print_status info "────────────────────────────────────────"
    print_status info "Confirmer le cycle merge/push ? (y/n) : " -n

    _ask || return 1

    print_status info "Lancement..."
    mergebranch "$branch_a_update"
}

# ─── Git : push pull all repo define in GIT_PATH_42 ───────────────────────────

_push_all_git() {

    # 1. On sépare la variable GIT_PATH_42 en utilisant le séparateur ':'
    # (s) divise la chaîne en tableau
    local paths=("${(@s/:/)1}")
    local count=0

    print_status info "Vérification des dépôts Git..."

    for repo in $paths; do

        # On vérifie si le dossier existe pour éviter les erreurs
        if [[ -d "$repo" ]]; then
        
            # On se déplace dans le dossier (dans un subshell pour ne pas changer le dossier courant de l'utilisateur)
            (
                cd "$repo"
                # On vérifie si c'est un dépôt Git
                if [[ -d ".git" ]]; then
                    # Utilisation de votre fonction interne _is_dirty
                    if _is_dirty; then
                        print_status info "Modifications détectées dans : $repo"
                        # Appel de votre fonction push interactive
                        push
                        ((count++))
                    fi
                fi
            )
        fi
    done

    print_status success "Vérification terminée ."
}

_pull_all_git() {

    # 1. On sépare la variable GIT_PATH_42 en utilisant le séparateur ':'
    # (s) divise la chaîne en tableau
    local paths=("${(@s/:/)1}")
    local count=0

    print_status info "Vérification des dépôts Git..."

    for repo in $paths; do

        # On vérifie si le dossier existe pour éviter les erreurs
        if [[ -d "$repo" ]]; then
        
            # On se déplace dans le dossier (dans un subshell pour ne pas changer le dossier courant de l'utilisateur)
            (
                cd "$repo"
                # On vérifie si c'est un dépôt Git
                if [[ -d ".git" ]]; then
                    if ! _is_dirty; then
                        git pull
                    else 
                        print_status info "Modifications détectées dans : $repo"
                    fi
                fi
            )
        fi
    done

    print_status success "Vérification terminée ."
}


if [[ "$where" == "42" ]]; then
    alias pull_all_git="_pull_all_git $GIT_PATH_42"
    alias push_all_git="_push_all_git $GIT_PATH_42"
else
    alias pull_all_git="_pull_all_git $GIT_PATH_MAISON"
    alias push_all_git="_push_all_git $GIT_PATH_MAISON"
fi

# ─── Git : config globale ─────────────────────────────────────────────────────

git_config() {
    git config --global user.email "florent.cretin@hotmail.fr"
    git config --global user.name  "Lzozoflo"
    git config --global pull.rebase false
    git config --global init.defaultBranch main
}


# ─── Git : .gitignore standard ───────────────────────────────────────────────

creatgitignore() {
    if [[ -f .gitignore ]]; then
        print_status info ".gitignore existe déjà — abandon pour éviter les doublons."
        return 1
    fi

    cat >> .gitignore << 'EOF'
*.log
*.env*
*secret*
node_modules/
build/
dist/
*out*
EOF

    print_status success ".gitignore créé."
}


# ─── Git : init complet ───────────────────────────────────────────────────────

gitinit() {
    case "$1" in
        ""|-h|--help)
            echo "Usage: gitinit <url_remote>"
            echo "       Initialise un repo git et push un premier commit."
            return 1
            ;;
    esac

    git_config

    if declare -f addreadme &>/dev/null; then
        addreadme
        mv -f BluePrintReadMeMain.md ReadMe.md 2>/dev/null
    else
        print_status info "addreadme non disponible — ReadMe ignoré."
    fi

    creatgitignore

    git init || return 1
    git add .
    git commit -m "first commit"    || return 1
    git branch -M main              || return 1
    git remote add origin "$1"      || return 1
    git push -u origin main         || return 1

    print_status success "Repo initialisé et pushé sur '$1' !"
}


