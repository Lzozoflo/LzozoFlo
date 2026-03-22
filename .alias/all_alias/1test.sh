
    # if [[ -n "$1" ]]; then est present

    # if [[ -z "$1" ]]; then n'est pas present


_params_present(){
    if [[ -n "$1" ]]; then
        return 0
    fi
    return 1
}
_params_pas_present(){
    if [[ -z "$1" ]]; then
        return 0
    fi
    return 1
}

_params_not_equal()){
    if [ $1 -ne 0 ]; then
        return 0
    fi
    return 1
}
