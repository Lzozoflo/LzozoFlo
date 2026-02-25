alias gm='git add . && git commit -m'
alias gw='git switch -'


alias remote_n_u='git remote add'
alias rv='git remote -v'




alias p="push"
alias psuh="p"





alias mergedev='mymerge "dev/frontend-hot-reload"'
alias pulldev='pullbranch "dev/frontend-hot-reload"'

# Fonction interne pour trouver le chemin sans déplacer le parent
_get_git_root() {
    if [ -d ".git" ]; then
        pwd
        return 0
    fi
    [ "$(pwd)" = "/" ] && return 1
    (cd .. && _get_git_root)
}
_is_dirty() {
    # Si la sortie est vide, le repo est propre. Sinon, il y a des changements.
    [[ -n $(git status --porcelain) ]]
}
_push(){

    if ! _is_dirty; then
        return 0
    fi

    if [[ "$2" != "--no-status"  ]]; then
        
        print_status info "Vous etes sur de vouloir push tout ca ?: "

        git status -s
        print_status info "Voulez vous utiliser push qui [add/commit/push] (y/n) : ${RESET}" -n
        local target=$(_ask) || return 1
    fi
    git add .               || {cd -;return 1;}
    git commit -m $1        || {cd -;return 1;}
    sleep 0.5               || {cd -;return 1;}
    git push                || {cd -;return 1;}
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



## git cmd push faster
push() {

    if [[ -n "$1" ]]; then
        _push $1 || return $?
        return 0
    fi

    if _is_dirty; then

        print_status info "Vous avez des modifications en cours (fichiers modifiés ou non suivis).\n"

        print_status info "Voulez vous utiliser push qui [add/commit/push] (y/n) : ${RESET}" -n
        read choice
        echo ""

        case "$choice" in 
            y|Y )


                # Vérifier qu'un argument est fourni
                print_status info "Effectue un git add/commit/push de : "

                git status -s

                print_status info "\tEntrer votre commit sans les ${TXT_ROUGE}''${RESET} : " -n
                read choice

                _push $choice "--no-status"

            ;;

            n|N )
                echo "${TXT_ROUGE}Annulation${RESET}" 
                return 1 ;;
            * ) 
                echo "${TXT_ROUGE}Réponse invalide${RESET}"
                return 1 ;;
        esac
    fi
}

pullbranch() {

    push || return 1

    local branch_actuel=$(git branch --show-current)
    local branch_a_update=$1

    sleep 0.1

    # Utilisation de 'set -e' pour stopper si une commande échoue (ex: conflit)
    print_status info "Update $branch_a_update..."
    git switch "$branch_a_update" && git pull || { print_status error "[pullbranch(1)] ta eu un problème bon chance poto" ; return 1}

    sleep 0.1

    print_status info "Merge $branch_a_update dans $branch_actuel..."
    git switch "$branch_actuel" && git merge "$branch_a_update" && git push || { print_status error "[pullbranch(2)] ta eu un problème bon chance poto";print_status info "ta juste quelque conflict fait moi ca sur vscode et recommence"; return 2}

    print_status success "la branch '$branch_actuel' a bien été update avec la branch '$branch_a_update' !"
}

mergebranch() {

    pullbranch $1 || return $?
    
    local branch_actuel=$(git branch --show-current)
    local branch_a_update=$1

    print_status info "Merge $branch_actuel dans $branch_a_update..."
    git switch "$branch_a_update" && git merge "$branch_actuel" && git push || { print_status error "[mergebranch(1)] ta eu un problème bon chance poto" ; return 3}

    sleep 0.1

    # Retour final sur la branche d'origine
    git switch "$branch_actuel"

    sleep 0.1

    print_status success "Pull et merge fini !"
}

mymerge() {

    if _is_dirty; then
         push || return 1
    fi

    local branch_actuel=$(git branch --show-current)
    local branch_a_update=$1

    if [ -z "$branch_a_update" ] || ! git show-ref --verify --quiet "refs/heads/$branch_a_update"; then
        print_status error "La branche '$branch_a_update' est invalide ou absente."
        return 1
    fi
    
    # 3. Confirmation unique et claire
    print_status info "--- RÉCAPITULATIF ---"
    print_status info "Branche actuelle        : '$branch_actuel'"
    print_status info "Branche à mettre à jour : '$branch_a_update'"
    print_status info "----------------------${RESET}"
    echo -n "${TXT_VERT}Confirmer le cycle merge/push ? (y/n) : ${RESET}"
    read choice

    case "$choice" in 
        y|Y ) 
            echo "${TXT_JAUNE}Lancement des opérations...${RESET}"
            mergebranch "$branch_a_update"
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