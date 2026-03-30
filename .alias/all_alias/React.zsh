############################################################


scss_transcendence_add() {
    if [[ -z "$1" ]]; then
        print_status error "Aucun nom de variable fourni."
        print_status info "Variables actuelles :"
        cat "$dstyle/_variable.scss"
        return 1
    fi
    if [[ -z "$2" ]]; then
        print_status error "Aucune valeur pour '\$$1'."
        return 1
    fi
    if grep -q "\$$1:" "$dstyle/_variable.scss"; then
        print_status error "'\$$1' existe déjà — utilise scss_transcendence_change."
        grep "\$$1:" "$dstyle/_variable.scss"
        return 1
    fi
    echo "\$$1: $2;" >> "$dstyle/_variable.scss"
    print_status success "Variable '\$$1: $2;' ajoutée."
}


scss_transcendence_change() {
    if [[ -z "$1" ]]; then
        print_status error "Aucun nom de variable fourni."
        print_status info "Variables actuelles :"
        cat "$dstyle/_variable.scss"
        return 1
    fi
    if [[ -z "$2" ]]; then
        print_status error "Aucune valeur pour '\$$1'."
        return 1
    fi

    if ! grep -q "\$$1:" "$dstyle/_variable.scss"; then
        print_status error "Variable '\$$1' introuvable."
        return 1
    fi

    sed -i "s/\$$1: .*/\$$1: $2;/" "$dstyle/_variable.scss"
    print_status success "\$$1: $2;"
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

<<<<<<< HEAD
alias run="npm install && npm run dev"
alias build="npm run build"
=======
createtsx() {
    if [[ -z "$1" ]]; then
        print_status error "Aucun nom de composant fourni."
        return 1
    fi
    if [[ -e "$PWD/$1" ]]; then
        print_status error "Le dossier '$1' existe déjà."
        return 1
    fi

    mkdir -p "$1"
    touch "$1/$1.scss" "$1/$1.tsx"
    print_status success "Composant '$1' créé."
}
>>>>>>> 745a94d677e5ce4c026f63da39692cd5c879009a


initreact() {

    # npm create vite@latest

    # Vérifier qu'un argument est fourni
    if [[ -z "$1" ]]; then
        echo "Erreur : aucun nom de dossier fourni !"
        return 1
    fi

    cp -r $dreact/base $dreact/exo/$1

    echo "# $1" > $dreact/exo/$1/Readme.md

    cd $dreact/exo/$1

    npm install
}

