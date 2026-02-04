
# Alias Open classroom
op() {
    # Vérifier qu'un argument est fourni
    if [[ -z "$1" ]]; then
        echo "Erreur : aucun nom de dossier fourni !"
        return 1
    fi

    if [[ ! -e "$PWD/$1" ]]; then
        echo "[info] Creation du dossier '$1'"
        mkdir -p $1
    fi

    cp -r * $1
    echo "[info] copy"

    echo "[info] check .git "
    if [[ -e "$PWD/$1/.git" ]]; then
        echo "[info] suppression du .git !"
        rm -fr $1/.git
    fi

    echo "[info] check README.md "
    if [[ -e "$PWD/$1/README.md" ]]; then
        echo "[info] suppression du README.md !"
        rm -fr $1/README.md
    fi

    echo "[info] move to $1"
    cd $1
}
