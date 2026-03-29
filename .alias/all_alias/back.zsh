
# error_count=0
# _sound() {
#     # !!! >/dev/null !!! <3
#     local exit_code=$?


#     if (( exit_code != 0 )); then
#         ((error_count++))
#     else
#         error_count=0
#     fi

#     if (( error_count >= 3 )); then
#         error_count=0
#         paplay "$spubfcretin/.regarde_pas_stp/fah.wav" >/dev/null 2>&1 &!

#         # precmd_functions=(${precmd_functions:#_sound})
#     fi
#     # !!! >/dev/null !!! <3
# }

# # ajoute un hook uniquement si il y est pas deja
# if [[ ! " ${precmd_functions[@]} " =~ " _sound " ]]; then
#     precmd_functions+=(_sound)
# fi
