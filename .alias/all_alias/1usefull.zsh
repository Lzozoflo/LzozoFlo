
alias c='clear'

# Valgrind alias (valgrind --leak-check=full --show-leak-kinds=all --show-mismatched-frees=yes --track-fds=yes --trace-children=yes)
export vgcool="--leak-check=full --show-leak-kinds=all"
export vgfull="$vgcool --track-origins=yes --show-mismatched-frees=yes --track-fds=yes --trace-children=yes"
alias vcool='valgrind $vgcool'
alias vfull='valgrind $vgfull'


alias m='make'
alias mvcool='make && vcool'
alias mvfull='make && vfull'


maketarget() {
    local target
    if target=$(_get_first_of Makefile); then   # ← teste directement, pas $? après
        make -s -C "$target" "$1"
    else
        return 1
    fi
}

# Mise à jour de tous les alias qui l'appellent
alias re="maketarget re"
alias fclean="maketarget fclean"
alias fclear="fclean"

alias dev="maketarget dev"
alias prod="maketarget prod"
alias studio="maketarget studio"
alias modeldb="maketarget modeldb"


place() {
    case "$1" in
        --help|-h)
            echo "Usage:"
            echo "  place [dossier]       — espace disque + du du dossier"
            return 0
            ;;
    esac

    df -h "$HOME" | tail -n 1
    echo ""
    du -h "$HOME/$1" --max-depth=1 2>/dev/null | sort -hr | head -n 15
}

treecat() {
    local target="${1:-.}"
    local output="${2:-out}"


    tree $target --gitignore -if -a \
        -I "node_modules|package-lock.json|.git|idee_de_jeu.jpg" | while read -r file; do
            if [ -f "$file" ]; then
            printf "\n\n--- FILE: %s ---\n" "$file" >> "$output"
            cat "$file" >> "$output"
        fi
    done

    print_status success "Résultat écrit dans '$output'."
}

# treecatstatus() {
#   # Récupère uniquement les fichiers suivis (M, A, etc.) ou non suivis (??)
#   # 'cut -c 4-' extrait le chemin du fichier après l'indicateur de statut Git
#   git status --porcelain | cut -c 4- | while read -r file; do
#     if [ -f "$file" ]; then
#       printf "\n\n--- FILE: %s ---\n" "$file" >> out
#       cat "$file" >> out
#     fi
#   done
# }


# ─── Utilitaires internes ─────────────────────────────────────────────────────

# Demande y/n — retourne 0 si "y", 1 sinon
_ask() {
    local reply
    read -r reply       # -r : ne pas interpréter les backslashes
    [[ "${reply:l}" == "y" ]]
}

# Cherche récursivement vers / le premier dossier contenant $1
# Affiche le chemin trouvé sur stdout, sans changer le répertoire courant
_get_first_of() {
    if [ -e "$1" ]; then
        pwd
        return 0
    fi
    [ "$(pwd)" = "/" ] && return 1
    (cd .. && _get_first_of "$1")
}

# Change de répertoire vers le premier ancêtre contenant $1
find_first_of() {
    local target
    target=$(_get_first_of "$1")

    if [ $? -eq 0 ]; then
        cd "$target" || return 1
    else
        print_status error "Aucun '$1' trouvé."
        return 1
    fi
}

# ─── Readme / Blueprint ───────────────────────────────────────────────────────

load_blueprint_export() {
    export blueprint="$dmarkdown/Blueprint/*"
    alias addreadme="cp $blueprint . -r"
}

