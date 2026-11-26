# _get_submodules_paths() {
#     local root_repo="$HOME/Project"
#     if [[ -f "$root_repo/.gitmodules" ]]; then
#         # Extrait directement tous les chemins du fichier
#         git config --file "$root_repo/.gitmodules" --get-regexp path | awk '{ print $2 }'
#     fi
# }

# _pull_all_git() {
#     local count=0
#     local root_repo="$HOME/Project"
    
#     print_status info "Vérification dynamique des sous-modules pour pull..."

#     for repo in $(_get_submodules_paths); do
#         local target="$root_repo/$repo"
        
#         if [[ -d "$target/.git" ]] || [[ -f "$target/.git" ]]; then
#             (
#                 cd "$target" || exit
#                 if ! _is_dirty; then
#                     git pull
#                     ((count++))
#                 else 
#                     print_status info "Ignoré (modifications en cours) : $repo"
#                 fi
#             )
#         fi
#     done

#     print_status success "Vérification pull terminée ($count mis à jour)."
# }

# alias pull_all_git="_pull_all_git"

