############################################################







scss_transcendence_add() {

    if [[ -z "$1" ]]; then
        echo -e "${TXT_ROUGE}[Erreur]: aucun nom de variable !${RESET}"
        echo -e "${TXT_JAUNE}[Info]: voila tout les variable a changer... ${RESET}"
        cat $dstyle/_variable.scss
        return 1
    fi
    if [[ -z "$2" ]]; then
        echo -e "${TXT_ROUGE}[Erreur]: aucune valeur pour $1: ?;${RESET}"
        return 1
    fi
    grep -q "\$$1:" "$dstyle/_variable.scss" && { echo -e "${TXT_ROUGE}Erreur: Le Noms de cette Variable est deja utiliser !${RESET}\n${TXT_JAUNE}[Info] Utiliser plutot [scss_transcendence_change]${RESET}"; grep "\$$1:" "$dstyle/_variable.scss"; return 1; }
    echo "\$$1: $2;" >> $dstyle/_variable.scss
}

scss_transcendence_change() {

    if [[ -z "$1" ]]; then
        echo -e "${TXT_ROUGE}[Erreur]: aucun nom de variable !${RESET}"
        echo -e "${TXT_JAUNE}[Info]: voila tout les variable a changer... ${RESET}"
        cat $dstyle/_variable.scss
        return 1
    fi
    if [[ -z "$2" ]]; then
        echo -e "${TXT_ROUGE}[Erreur]: aucune valeur pour $1: ?;${RESET}"
        return 1
    fi

    grep -q "\$$1:" "$dstyle/_variable.scss" && grep "\$$1:" "$dstyle/_variable.scss" || { echo -e "${TXT_ROUGE}Erreur: Aucune Variable du nom de $1${RESET}"; return 1; }
    sed -i "s/\$$1: .*/\$$1: $2;/" "$dstyle/_variable.scss"
    echo -e "${GRAS}${TXT_ROUGE}\$$1:${RESET} $2;"
}



alias run="npm install && npm run dev"
alias build="npm run build"

headerscss(){
        echo '// @use "STYLE/variable" as var;'
        echo '//    var.$border_value;\n'
        echo '// @use "STYLE/_mixin" as mix;'
        echo '//    @include mix.full;\n'
    if [[ -n "$1" ]]; then
        echo ".$1-root{\n\n}"
    fi
}

headerjsx(){
    echo "/* extern */"
    echo "import { useEffect, useState } from \"react\";"
    echo ""
    echo "/* back */"
    echo "import checkCo from \"BACK/fct1.js\""
    echo ""
    echo "/* Css */"

    if [[ -n "$1" ]]; then
    echo "import \"./$1.scss\";"
    fi

    echo ""
    echo "/* Components */"
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
    
    headerscss $1 > $1/$1.scss
    
    headerjsx $1 > $1/$1.jsx

    echo "

    
export default function $1() {
    return (
        <div className={\`$1-root\`}>
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
