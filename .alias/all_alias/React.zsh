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

    
alias logtrans="make -s -C $dtranscendence/.. logs"
alias logtransp="make -s -C $dtranscendence/.. logsparam"
alias logttrans="make -s -C $dtranscendence/.. logst"
alias _logtrans="make -s -C $dtranscendence/.. logs_alert_flo"
logtrans_alert() {
    print_status info "Lancement de logtrans_alert..."
    local buffer=()
    
    while IFS= read -r line; do
        # Nettoyage
        line=$(echo "$line" | sed 's/\r//g; s/\x1b\[[0-9;]*m//g')
        
        buffer+=("$line")

        # Gestion du buffer (max 3)
        if [ "${#buffer[@]}" -gt 3 ]; then
            # Version compatible Bash/Zsh pour retirer le premier élément
            buffer=("${buffer[@]:1}")
        fi

        # Debug simple et compatible
        # echo "--- BUFFER (${#buffer[@]} lignes) ---"
        # printf " > %s\n" "${buffer[@]}"

        # Vérification
        if [ "${#buffer[@]}" -eq 3 ]; then
            if [[ "${buffer[1]}" == *"[0] WebSocket server initialized on path /ws"* ]] && \
               [[ "${buffer[2]}" == *"[0] Server running on http://localhost:9000"* ]] && \
               [[ "${buffer[3]}" == *"[0] Proxying front to Vite at http://localhost:5173"* ]]; then
                
                notify-send "Back-end ready.."
                paplay "$spubfcretin/.regarde_pas_stp/fah.wav" >/dev/null 2>&1 &!
            fi
        fi
    done < <(_logtrans 2>&1)
}

alias run="npm install && npm run dev"
alias build="npm run build"


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
