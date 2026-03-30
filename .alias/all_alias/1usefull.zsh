
alias c='clear'
alias m='make'

# Valgrind alias (valgrind --leak-check=full --show-leak-kinds=all --show-mismatched-frees=yes --track-fds=yes --trace-children=yes)
export vgcool="--leak-check=full --show-leak-kinds=all"
export vgfull="$vgcool --track-origins=yes --show-mismatched-frees=yes --track-fds=yes --trace-children=yes"
alias vcool='valgrind $vgcool'
alias vfull='valgrind $vgfull'
alias mvcool='m && vcool'
alias mvfull='m && vfull'






place() {

    # Help
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage:"
        echo "  place dossier"
        echo "  place -rm dossier"
        echo "  place -rmfr dossier"
        return 0
    fi

    # rm interactif (dossier)
    if [[ "$1" == "-rm" ]]; then
        if [[ -z "$2" ]]; then
            echo "Specify a path."
            return 1
        fi
        rm -ri "$HOME/$2"
        return $?
    fi
   

    # affichage espace disque
    df -h "$HOME" | tail -n 1

    echo ""

    # rm interactif (dossier)
    du -h "$HOME/$1" --max-depth=1 2>/dev/null | sort -hr | head -n 15
}







addheader_infilef(){
    # Vérifier qu'un argument
    if [[ -z "$1" ]]; then
        echo "${TXT_ROUGE}[Erreur] : Rien a ajouter !${RESET}"
        return 1
    fi

    # Vérifier qu'un argument est fourni
    if [[ -z "$2" ]]; then
        echo "${TXT_ROUGE}[Erreur] : aucun nom de fichier fourni !${RESET}"
        return 1
    fi

    $1 $2 > "$2.tmp"

    cat "$2" | >> "$2.tmp"

    mv "$2.tmp" "$2"
}

addheader_infile(){
    # Vérifier qu'un argument
    if [[ -z "$1" ]]; then
        echo "${TXT_ROUGE}[Erreur] : Rien a ajouter !${RESET}"
        return 1
    fi

    # Vérifier qu'un argument est fourni
    if [[ -z "$2" ]]; then
        echo "${TXT_ROUGE}[Erreur] : aucun nom de fichier fourni !${RESET}"
        return 1
    fi

    echo $1 > "$2.tmp"

    cat "$2" | >> "$2.tmp"

    mv "$2.tmp" "$2"
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


_ask_choice(){
    # local target
    # target=$(_ask) || return 1
    echo ""
    read choice
    echo $choice
}

_ask(){
    echo $1 -n
    read choice
    case "$choice" in 
        y|Y ) 
            return 0;;
        n|N )
            echo "${TXT_ROUGE}Annulation...${RESET}" 
            return 1;;
        * ) 
            echo "${TXT_ROUGE}Réponse invalide...${RESET}"
            return 1 ;;
    esac
}


alias re="maketraget re"
alias fclean="maketraget fclean"
alias fclear="fclean"

alias dev="maketraget dev"
alias prod="maketraget prod"
alias studio="maketraget studio"
alias modeldb="maketraget modeldb"

maketraget() {
    local target
    target=$(_get_frist_of Makefile)

    if [ $? -eq 0 ]; then
        make -s -C $target $1
    else
        return 1
    fi
}


treecat() {
  local target="${1:-.}"

  # -I permet d'exclure des patterns spécifiques séparés par |

  tree $target --gitignore -if -I "out|node_modules|package-lock.json|.git|Game|package-look.json" -a | while read -r file; do
    if [ -f "$file" ]; then
      printf "\n\n--- FILE: %s ---\n" "$file" >> out
      cat "$file" >> out
    fi
  done
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