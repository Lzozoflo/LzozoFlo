############################################################
alias run="npm install && npm run dev"
alias build="npm run build"

headercpyjsx(){
    headerjsx > "$1.tmp"

    cat "$1" | >> "$1.tmp"

    mv "$1.tmp" "$1"
}

headerjsx(){

    
    echo "/* extern */
import { useEffect, useState } from "react";

/* back */
import checkCo from "BACK/fct1.js"

/* Css */
import \"./$1.scss\";

/* Components */"

}

createjsx(){

    # Vérifier qu'un argument est fourni
    if [[ -z "$1" ]]; then
        echo "Erreur : aucun nom de fichier fourni !"
        return 1
    fi

    if [[  -e "$PWD/$1" ]]; then
        echo "Erreur : le file existe deja !"
        return 1
    fi

    mkdir $1
    
    touch $1/$1.scss
    
    headerjsx > $1/$1.jsx

    echo "

    
export default function $1() {
    return (
        <div className={\`$1\`}>
        yo c'est david la farge
        </div>
    )
}" >> $1/$1.jsx

}


















initreact() {

    # npm create vite@latest

    # Vérifier qu'un argument est fourni
    if [[ -z "$1" ]]; then
        echo "Erreur : aucun nom de dossier fourni !"
        return 1
    fi

    cp -r $d_react/base $d_react/exo/$1

    echo "# $1" > $d_react/exo/$1/Readme.md

    cd $d_react/exo/$1

    npm install
}
