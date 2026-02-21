

# switchmerge() {
    
#     local branch_actuel=$(git branch --show-current)
#     local branch_a_update=$1
    
#     # Vérifie si on est bien dans un dépôt git
#     if [ -z "$branch_actuel" ]; then
#         echo "Erreur : Pas un dépôt Git."
#         return 1
#     fi

#     # Vérifie que l'argument 1 est fourni ET qu'il s'agit d'une branche existante
#     if [ -z "$branch_a_update" ] || ! git show-ref --verify --quiet "refs/heads/$branch_a_update"; then
#         echo "Erreur : La branche n'a pas été spécifiée ou '$branch_a_update' n'existe pas."
#         return 1
#     fi

#     echo "Confirmer avoir bien tout push sur votre propre branch ? (y/n) : "
#     read choice
#     case "$choice" in 
#         y|Y ) echo "";;
#         n|N ) echo "Annulation" 
#             return 1 ;;
#         * ) echo "Réponse invalide"
#             return 1 ;;
#     esac


#     echo "Branche actuelle : '$branch_actuel'"
#     echo -n "Confirmer l'action sur $branch_actuel ? (y/n) : "
#     read choice
#     case "$choice" in 
#         y|Y ) echo "";;
#         n|N ) echo "Annulation" 
#             return 1 ;;
#         * ) echo "Réponse invalide"
#             return 1 ;;
#     esac

#     echo "Branche sur la quelle merge : '$branch_a_update'"
#     echo -n "Confirmer l'action sur $branch_a_update ? (y/n) : "
#     read choice
    

#     case "$choice" in
#         y|Y ) 
#             echo "Action exécutée sur $branch_actuel..."

#             updatemerge $branch_actuel $branch_a_update
            

#             # Ajoutez vos commandes git merge ici
#             ;;
#         n|N ) 
#             echo "Annulation"
#             return 1 
#             ;;
#         * ) 
#             echo "Réponse invalide"
#             return 1 
#             ;;
#     esac
# }




# updatemerge () {
    
#     local branch_actuel=$1
#     local branch_a_update=$2


#     if [ -z "$branch_actuel" ]; then
#         echo "Erreur : Pas un dépôt Git."
#         return 1
#     fi

#     echo "branch_actuel : $branch_actuel."
#     echo "branch_a_update : $branch_a_update."


#     git switch $branch_a_update

#     git pull

#     git switch $branch_actuel

#     git merge $branch_a_update

#     git push

#     git switch $branch_a_update

#     git merge $branch_actuel

#     git push

# }
