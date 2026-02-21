
alias gm='git add . && git commit -m'
alias gw='git switch -'


alias remote_n_u='git remote add'
alias rv='git remote -v'




alias p="push"
alias psuh="p"



alias mergedev='mymerge "dev/frontend-hot-reload"'

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


    # Utilisation dans votre switchmerge :
    if is_dirty; then
        echo "Erreur : Vous avez des modifications en cours (fichiers modifiés ou non suivis)."
        echo "Veuillez commit ou stash vos changements avant de continuer."
        git status -s
        return 1
    fi

    # Utilisation de 'set -e' pour stopper si une commande échoue (ex: conflit)
    echo "-> Update $branch_a_update..."
    git switch "$branch_a_update" && git pull || return 1

    echo "-> Merge $branch_a_update dans $branch_actuel..."
    git switch "$branch_actuel" && git merge "$branch_a_update" && git push || return 1

    echo "-> Merge $branch_actuel dans $branch_a_update..."
    git switch "$branch_a_update" && git merge "$branch_actuel" && git push || return 1

    # Retour final sur la branche d'origine
    git switch "$branch_actuel"
    echo "Terminé avec succès !"
}



mymerge() {
    local branch_actuel=$(git branch --show-current)
    local branch_a_update=$1
    
    # 1. Vérifications de base
    if [ -z "$branch_actuel" ]; then
        echo "Erreur : Pas dans un dépôt Git."
        return 1
    fi

    if [ -z "$branch_a_update" ] || ! git show-ref --verify --quiet "refs/heads/$branch_a_update"; then
        echo "Erreur : La branche '$branch_a_update' est invalide ou absente."
        return 1
    fi

    echo -n "Confirmer avoir bien tout push sur votre propre branch ? (y/p(utilise push)/n) : "
    read choice
    case "$choice" in 
        y|Y ) echo "";;
        p|P ) echo 'Effectue un git add/commit/push'
              echo -n 'Entrer entre "" votre commit: '
            read choice
            push $choice || return 1;;

        n|N ) echo "Annulation" 
            return 1 ;;
        * ) echo "Réponse invalide"
            return 1 ;;
    esac

    
    # 2. Confirmation unique et claire
    echo "--- RÉCAPITULATIF ---"
    echo "Branche actuelle        : '$branch_actuel'"
    echo "Branche à mettre à jour : '$branch_a_update'"
    echo "----------------------"
    echo -n "Confirmer le cycle merge/push ? (y/n) : "
    read choice

    case "$choice" in 
        y|Y ) 
            echo "Lancement des opérations..."
            updatemerge "$branch_a_update"
            ;;
        *) 
            echo "Annulation."
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