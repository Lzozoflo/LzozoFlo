alias gm='git add . && git commit -m'
alias gw='git switch -'


alias remote_n_u='git remote add'
alias rv='git remote -v'




alias p="push"
alias psuh="p"



export dtranscendence="$dproject/ft_transcendence"
alias mergedev='mymerge "dev/frontend-hot-reload"'











# Fonction interne pour trouver le chemin sans déplacer le parent
_get_git_root() {
    if [ -d ".git" ]; then
        pwd
        return 0
    fi
    [ "$(pwd)" = "/" ] && return 1
    (cd .. && _get_git_root)
}

# Fonction principale à appeler
find_dot_git() {
    local target
    target=$(_get_git_root)

    if [ $? -eq 0 ]; then
        cd "$target"
    else
        echo -e "${TXT_ROUGE}Aucun dépôt .git trouvé.${RESET}"
        return 1
    fi
}









is_dirty() {
    # Si la sortie est vide, le repo est propre. Sinon, il y a des changements.
    [[ -n $(git status --porcelain) ]]
}


## git cmd push faster
push() {
    # Vérifier qu'un argument est fourni
    if [[ -z "$1" ]]; then
        echo "Erreur : aucun nom de commit fourni !"
        return 1
    fi

    git add . || return 1
    
    git commit -m $1 || return 1
    
    sleep 0.5 || return 1
    
    git push || return 1
}



updatemerge() {
    local branch_actuel=$(git branch --show-current)
    local branch_a_update=$1

    sleep 0.1

    # Utilisation de 'set -e' pour stopper si une commande échoue (ex: conflit)
    echo "[Info] Update $branch_a_update..."
    git switch "$branch_a_update" && git pull || return 1

    sleep 0.1

    echo "[Info] Merge $branch_a_update dans $branch_actuel..."
    git switch "$branch_actuel" && git merge "$branch_a_update" && git push || return 1

    sleep 0.1

    echo "[Info] Merge $branch_actuel dans $branch_a_update..."
    git switch "$branch_a_update" && git merge "$branch_actuel" && git push || return 1

    sleep 0.1

    # Retour final sur la branche d'origine
    git switch "$branch_actuel"

    sleep 0.1

    echo "Terminé avec succès !"
}


is_dirty() {
    # Si la sortie est vide, le repo est propre. Sinon, il y a des changements.
    [[ -n $(git status --porcelain) ]]
}

mymerge() {

    find_dot_git || return 1;
    
    local branch_actuel=$(git branch --show-current)
    local branch_a_update=$1
    

    if [ -z "$branch_a_update" ] || ! git show-ref --verify --quiet "refs/heads/$branch_a_update"; then
        echo "${TXT_ROUGE}La branche '$branch_a_update' est invalide ou absente.${RESET}"
        return 1
    fi


    # 2. Vérifications du status
    if is_dirty; then

        echo "${TXT_JAUNE}[INFO] Vous avez des modifications en cours (fichiers modifiés ou non suivis).${RESET}"

        git status -s

        echo "${TXT_JAUNE}[INFO] Veuillez commit vos changements avant de continuer...${RESET}\n"

        echo -n "${TXT_BLEU}Voulez vous utiliser push qui [add/commit/push] (y/n) : ${RESET}"
        read choice
        echo -n "${RESET}"

        case "$choice" in 
            y|Y ) echo "${TXT_JAUNE}[INFO] Effectue un git add/commit/push${RESET}"
                echo -n "\t${TXT_VERT}Entrer votre commit sans les ${TXT_ROUGE}''${RESET} : "
                read choice
                push $choice || return 1;;
            n|N ) echo "${TXT_ROUGE}Annulation${RESET}" 
                return 1 ;;
            * ) echo "${TXT_ROUGE}Réponse invalide${RESET}"
                return 1 ;;
        esac
    fi

    cd -

    # 3. Confirmation unique et claire
    echo "${TXT_JAUNE}--- RÉCAPITULATIF ---"
    echo "Branche actuelle        : '$branch_actuel'"
    echo "Branche à mettre à jour : '$branch_a_update'"
    echo "----------------------${RESET}"
    echo -n "${TXT_VERT}Confirmer le cycle merge/push ? (y/n) : ${RESET}"
    read choice

    case "$choice" in 
        y|Y ) 
            echo "Lancement des opérations..."
            updatemerge "$branch_a_update"
            ;;
        *) 
            echo "${TXT_ROUGE}Annulation.${RESET}"
            return 1 
            ;;
    esac
}











## init better
gitinit() {

    # Vérifier qu'un argument est fourni
    if [[ -z "$1" ]]; then
        echo "Erreur : gitinit <--help> / <-h>"
        return 1
    fi

    # cmd help
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: gitinit [the new remote]"
        echo "Info: the commit was 'first commit'"
        return 1
    fi
    
    git init

    git add Readme.md

    git commit -m "first commit"

    git branch -M main

    git remote add origin $1

    git push -u origin main
    
}