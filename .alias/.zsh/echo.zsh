# ─── Variables de couleur ─────────────────────────────────────────────────────
TXT_NOIR='\e[30m'   TXT_ROUGE='\e[31m'  TXT_VERT='\e[32m'
TXT_JAUNE='\e[33m'  TXT_BLEU='\e[34m'  TXT_MAGENTA='\e[35m'
TXT_CYAN='\e[36m'   TXT_BLANC='\e[37m'

# ─── Variables de style ───────────────────────────────────────────────────────
RESET='\e[0m'   GRAS='\e[1m'    ATTENUE='\e[2m'
ITALIQUE='\e[3m' SOULIGNE='\e[4m'

# ─── Variables de fond ────────────────────────────────────────────────────────
FOND_NOIR='\e[40m'   FOND_ROUGE='\e[41m'  FOND_VERT='\e[42m'
FOND_JAUNE='\e[43m'  FOND_BLEU='\e[44m'  FOND_MAGENTA='\e[45m'
FOND_CYAN='\e[46m'   FOND_BLANC='\e[47m'

# ─── print_status ────────────────────────────────────────────────────────────
# Usage : print_status <level> <message> [-n]
#   level   : error | success | info  (et leurs variantes)
#   message : texte à afficher
#   -n      : optionnel, pas de saut de ligne final
print_status() {
    local level="${1:-}"
    local message="${2:-}"
    local flag="${3:-}"       # optionnel : -n

    if [[ -z "$level" ]]; then
        printf '%b\n' "${TXT_ROUGE}[Error] : aucun level fourni.${RESET}"
        printf '%b\n' "${TXT_JAUNE}Niveaux disponibles : error | success | info${RESET}"
        return 1
    fi

    if [[ -z "$message" ]]; then
        printf '%b\n' "${TXT_JAUNE}[Info] : message vide.${RESET}"
        return 1
    fi

    local color status_label
    case "${level:l}" in   # ${:l} = lowercase, plus besoin de 10 variantes
        error|erreur|"[error]"|"[erreur]")
            color=$TXT_ROUGE ; status_label="[Error]" ;;
        success|"[success]")
            color=$TXT_VERT  ; status_label="[Success]" ;;
        info|"[info]")
            color=$TXT_JAUNE ; status_label="[Info]" ;;
        *)
            color=$TXT_BLANC ; status_label="[?]" ;;
    esac

    # printf gère -n nativement via le format : pas de saut de ligne si flag=-n
    if [[ "$flag" == "-n" ]]; then
        printf '%b' "${color}${status_label} : ${message}${RESET}"
    else
        printf '%b\n' "${color}${status_label} : ${message}${RESET}"
    fi
}