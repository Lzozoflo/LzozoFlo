
alias gm='git add . && git commit -m'

alias remote_n_u='git remote add'

alias rv='git remote -v'





alias p="push"
alias psuh="p"






## git cmd push faster
push() {
    # Vérifier qu'un argument est fourni
    if [[ -z "$1" ]]; then
        echo "Erreur : aucun nom de commit fourni !"
        return 1
    fi

    git add .
    
    git commit -m $1
    
    sleep 0.5
    
    git push
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