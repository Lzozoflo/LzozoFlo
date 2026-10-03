export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="af-magic"
plugins=(git)
source $ZSH/oh-my-zsh.sh



export DIR_DOTFILE="$HOME/Project/LzozoFlo"
export ALIAS="$DIR_DOTFILE/.alias"

export  SNIPPETS="$DIR_DOTFILE/.snippets"
ln -sf $SNIPPETS $HOME/.config/Code/User/snippets


alias alss='code $ALIAS'
if [ -d "$ALIAS" ]; then
    printf "all .dotfiles.alias sourced :\n\n"
    while IFS= read -r file; do
        source "$file"
        printf "Chargé : %s\n" "$file"
    done < <(find "$ALIAS" -type f -name "*.zsh" ! -name ".zshrc")
fi

if [[ "$HOME" == "/home/fcretin" ]]; then
    path
    load_blueprint_export
fi


# alias als='code $DIR_DOTFILE'
# alias alshome='code ~/.zshrc'
# alias sauce='source ~/.zshrc'
# source $HOME/.myzshrc