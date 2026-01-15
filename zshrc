
export project_dir="$HOME/project"

export blueprint_readme="$project_dir/formation_extern/Markdown/Blueprint/BluePrintReadMeMain.md"

# the life
alias als='code ~/.zshrc'
alias sauce='source ~/.zshrc'
alias c='clear'
alias son="/sgoinfre/scros/Public/utils/blue42"
alias sonnb='systemctl --user start pulseaudio && systemctl --user enable pulseaudio'
alias addreadme="cp $blueprint_readme . -r"

# Makefile alias
alias cm='c; make'
alias m='make'
alias mc='make clean'
alias mf='make fclean'
alias mr='make re'


#############################################################################################
#                                          git cmd                                          #
#############################################################################################

alias gm='git add . && git commit -m'
alias remote_n_u='git remote add'
alias rv='git remote -v'
alias push="p"
alias psuh="p"
## git cmd push faster
p() {
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
        echo "Erreur : ./script.sh <--help> / <-h>"
        return 1
    fi


    # cmd help
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: ./script.sh [the file add to commit] [the new remote]"
        echo "Info: the commit was 'frist commit'"
        return 0
    fi
    
    # Vérifier qu'un 2eme argument est fourni
    if [[ -z "$2" ]]; then
        echo "Erreur : ./script.sh <--help> / <-h>"
        echo "Info: the commit was 'frist commit'"
        return 1
    fi

    git init
    git add $1
    git commit -m "first commit"
    git branch -M main
    git remote add origin $2
    git push -u origin main
}

#############################################################################################


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

    cp -r 1openclass/* $1

    echo "[info] check .git "
    if [[ -e "$PWD/$1/.git" ]]; then
        echo "[info] suppression du .git !"
        rm -fr $1/.git
        return 0
    fi

    echo "[info] check .README.md "
    if [[ -e "$PWD/$1/README.md" ]]; then
        echo "[info] suppression du README.md !"
        rm -fr $1/README.md
        return 0
    fi

}

#help 
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



# valgrind --leak-check=full --show-leak-kinds=all --show-mismatched-frees=yes --track-fds=yes --trace-children=yes
export vgcool='--leak-check=full --show-leak-kinds=all'
export vgfull='--leak-check=full --show-leak-kinds=all --track-origins=yes --show-mismatched-frees=yes --track-fds=yes --trace-children=yes'
alias vcool='valgrind $vgcool'
alias vfull='valgrind $vgfull'
alias mvcool='m && vcool'
alias mvfull='m && vfull'


# exemple alias for every exec
alias name="mr && $HOME/a.out"
alias namevc="mvcool $HOME/a.out"
alias namevf="mvfull $HOME/a.out"
