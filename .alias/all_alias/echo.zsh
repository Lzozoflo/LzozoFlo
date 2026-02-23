
# Variables de texte
TXT_NOIR='\e[30m'
TXT_ROUGE='\e[31m'
TXT_VERT='\e[32m'
TXT_JAUNE='\e[33m'
TXT_BLEU='\e[34m'
TXT_MAGENTA='\e[35m'
TXT_CYAN='\e[36m'
TXT_BLANC='\e[37m'


# Variables de style
RESET='\e[0m'
GRAS='\e[1m'
ATTENUE='\e[2m'
ITALIQUE='\e[3m'
SOULIGNE='\e[4m'
CLIGNOTANT='\e[5m'
CLIGNOTANT_RAPIDE='\e[6m'
INVERSE='\e[7m'


# Variables de fond
FOND_NOIR='\e[40m'
FOND_ROUGE='\e[41m'
FOND_VERT='\e[42m'
FOND_JAUNE='\e[43m'
FOND_BLEU='\e[44m'
FOND_MAGENTA='\e[45m'
FOND_CYAN='\e[46m'
FOND_BLANC='\e[47m'



color(){


    local color_choice=$TXT_BLANC
    local type_choice=$RESET
    local bg_choice=""

    # $1 : Couleur du texte
    case $2 in
        "blue"|"bleu") color_choice=$TXT_BLEU ;;
        "red"|"rouge") color_choice=$TXT_ROUGE ;;
        "green"|"vert") color_choice=$TXT_VERT ;;
        "yellow"|"jaune") color_choice=$TXT_JAUNE ;;
        "magenta") color_choice=$TXT_MAGENTA ;;
        "cyan") color_choice=$TXT_CYAN ;;
        "black"|"noir") color_choice=$TXT_NOIR ;;
        *) color_choice=$TXT_BLANC ;;
    esac

    # $3 : Style de texte
    case $3 in
        "bold"|"gras") type_choice=$GRAS ;;
        "dim"|"attenue") type_choice=$ATTENUE ;;
        "italic"|"italique") type_choice=$ITALIQUE ;;
        "underline"|"souligne") type_choice=$SOULIGNE ;;
        "blink"|"clignotant") type_choice=$CLIGNOTANT ;;
        "inverse") type_choice=$INVERSE ;;
        *) type_choice=$RESET ;;
    esac

    # $4 : Couleur de fond
    case $4 in
        "red"|"rouge") bg_choice=$FOND_ROUGE ;;
        "green"|"vert") bg_choice=$FOND_VERT ;;
        "yellow"|"jaune") bg_choice=$FOND_JAUNE ;;
        "blue"|"bleu") bg_choice=$FOND_BLEU ;;
        "magenta") bg_choice=$FOND_MAGENTA ;;
        "cyan") bg_choice=$FOND_CYAN ;;
        "black"|"noir") bg_choice=$FOND_NOIR ;;
        "white"|"blanc") bg_choice=$FOND_BLANC ;;
        *) bg_choice="" ;;
    esac

    echo -e "${type_choice}${bg_choice}${color_choice}${1}${RESET}"
}


print_status(){

    # Vérifier qu'un argument est fourni
    if [[ -z "$1" ]]; then
        echo "${TXT_ROUGE}[Erreur] : aucun status fourni !${RESET}"
        echo "${TXT_JAUNE}[Info] : voici la liste des status dispo...${RESET}"
        echo "${TXT_GREEN}[Success] : ceci est vert tu a success bg...${RESET}"
        echo "Du coup : ${TXT_ROUGE}'Erreur'${TXT_JAUNE}'Info'${TXT_GREEN}'Success'${RESET}"
        return 1
    fi    # Vérifier qu'un argument est fourni
    if [[ -z "$2" ]]; then
        echo "${TXT_JAUNE}[Info] : Euh ta rien mis a print la${RESET}"
        return 1
    fi

    local color=$TXT_BLANC
    local status_print=$TXT_BLANC

    case $1 in
        "Erreur"|"[Erreur]"|"Error"|"[Error]"|"error"|"erreur") color=$TXT_ROUGE status_print="[Error]";;
        "Success"|"[Success]"|"success") color=$TXT_VERT status_print="[Success]";;
        "Info"|"[Info]"|"info") color=$TXT_JAUNE status_print="[Info]";;
        *) color=$TXT_BLANC status_print="[unknow]";;
    esac

    echo -e $3 "$color$status_print : $2${RESET}"
}