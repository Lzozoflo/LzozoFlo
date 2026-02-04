
# Makefile alias
alias c='clear'
alias m='make'
alias cm='c; m'
alias mc='m clean'
alias mf='m fclean'
alias mr='m re'

# Valgrind alias (valgrind --leak-check=full --show-leak-kinds=all --show-mismatched-frees=yes --track-fds=yes --trace-children=yes)
export vgcool="--leak-check=full --show-leak-kinds=all"
export vgfull="$vgcool --track-origins=yes --show-mismatched-frees=yes --track-fds=yes --trace-children=yes"
alias vcool='valgrind $vgcool'
alias vfull='valgrind $vgfull'
alias mvcool='m && vcool'
alias mvfull='m && vfull'


# Readme
export blueprint="$d_markdown/Blueprint/BluePrintReadMeMain.md"
alias addreadme="cp $blueprint Readme.md -r"
alias codereadme="code $blueprint"


place() {

    # cmd help
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: place [the path after your home]"
        return 1
    fi

    du -h $HOME/$1 --max-depth=1 | sort -hr | head -n 20

}


# help
correc_here() {

    # Vérifier qu'un argument est fourni
    if [[ -z "$1" ]]; then
        echo "Erreur : aucun nom de dossier fourni !"
        return 1
    fi

    # Vérifier si le dossier existe déjà
    if [[ -e "$HOME/goinfre/$1" ]]; then
        echo "Erreur : '$1' existe déjà !"
        return 1
    fi

    # Récupérer l'URL du remote vog
    if [[ -z "$2" ]]; then
        url=$(git remote get-url vog 2>/dev/null)
    else
        url=$(git remote get-url $2 2>/dev/null)
    fi

    # Vérifier que l'URL existe
    if [[ -z "$url" ]]; then
        echo "Remote introuvable !"
        return 1
    fi

    # Aller dans le bon dossier
    cd $HOME/goinfre

    # Cloner dans le dossier donné en argument
    git clone "$url" "$1"

    # Aller dans le clone
    cd $HOME/goinfre/$1
}