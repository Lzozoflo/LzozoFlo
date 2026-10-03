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
    for file in $(find "$ALIAS" -name "*.zsh"); do
        source "$file"
    done
fi

if [[ "$HOME" == "/home/fcretin" ]]; then
    path_Repo_Project
    load_blueprint_export
fi


alias als='code $DIR_DOTFILE/.zshrc'
alias alshome='code ~/.zshrc'
alias sauce='source ~/.zshrc'
source $HOME/.myzshrc