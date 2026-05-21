

# ─── 42 ──────────────────────────────────────────────────────────────

path_42(){

    export dproject="$HOME/project"                                         # project
    export dcc="$dproject/cc"                                               # ├── cc
        export dcpp0="$dcc/CPP_00"                                          # │   ├── CPP_00
        export dcpp2="$dcc/CPP_02"                                          # │   ├── CPP_02
        export dcpp5="$dcc/CPP_05"                                          # │   ├── CPP_05
        export dcpp7="$dcc/CPP_07"                                          # │   ├── CPP_07
        export dcpp8="$dcc/CPP_08"                                          # │   ├── CPP_08
        export dcpp9="$dcc/CPP_09"                                          # │   ├── CPP_09
        export dtranscendence="$dcc/ft_transcendence/web"                   # │   ├── ft_transcendence
            export dback="$dtranscendence/back/src"                         # │   │   ├── "..."
            export dfront="$dtranscendence/front"                           # │   │   ├── "..."
            export dpage="$dfront/src/page"                                 # │   │   ├── "..."
            export dstyle="$dfront/src/style"                               # │   │   ├── "..."
            export fborder="$dfront/src/style/global/border.scss"           # │   │   └── "..."
        export dlibft="$dcc/libft"                                          # │   │   ├── libft
        export dwebserve="$dcc/webserv"                                     # │   └── webserv
                                                                            # │
    export allcc=dcpp0:$dcpp2:$dcpp5:$dcpp7:$dcpp8:$dcpp9                   # │
    export allcc=$allcc:$dtranscendence:$dlibft:$dwebserve                        # │
                                                                            # │
    export dformation_extern="$dproject/formation_extern"                   # ├── formation_extern
        export dmatrix="$dformation_extern/Extensions_Matrix_42lyon"        # │   ├── Extensions_Matrix_42lyon
        export dhtml="$dformation_extern/HTML_CSS"                          # │   ├── HTML_CSS
        export djavescript="$dformation_extern/JavaScript"                  # │   ├── JavaScript
        export dmarkdown="$dformation_extern/Markdown"                      # │   ├── Markdown
        export dpro="$dformation_extern/Portfolio"                          # │   ├── Portfolio
        export dreact="$dformation_extern/React"                            # │   ├── React
        export droot="$dformation_extern/root_me"                           # │   ├── root_me
        export dtypescript="$dformation_extern/TypeScript"                  # │   └── TypeScript
                                                                            # │
    export allextern=$dmatrix:$dhtml:$djavescript:$dpro:$dreact             # │
    export allextern=$dmarkdown:$allextern:$droot:$dtypescript              # │
                                                                            # │
    export dpostcc="$dproject/postcc"                                       # ├── postcc
        export dlibasm="$dpostcc/libasm"                                    # │   ├── libasm
        export dping="$dpostcc/ping"                                        # │   ├── ping
        export dsnow="$dpostcc/SnowCrash"                                   # │   ├── SnowCrash
        export drain="$dpostcc/Rainfall"                                    # │   ├── Rainfall
                                                                            # │
    export allpostcc=$dlibasm:$dping:$dsnow:$dsnow:$drain                   # │

    export GIT_PATH_42=$allcc:$allextern:$allpostcc

}


# ─── Maison ──────────────────────────────────────────────────────────────

path_maison(){

    export dproject="$HOME/project"                                     # project
        export dtranscendence="$dproject/ft_transcendence/web"          # ├── ft_transcendence
        export ddotfile="$dproject/LzozoFlo"                            # ├── LzozoFlo
        export dmarkdown="$dproject/Markdown"                           # ├── Markdown
        export dportfolio="$dproject/portfolio"                         # └── portfolio
            export dpro="$dportfolio/Portfolio"                         #     ├── Portfolio    branch : main
            export dsite_file="$dportfolio/readme"                      #     └── readme       branch : site_file

    export GIT_PATH_MAISON="$dproject:$dtranscendence:$ddotfile:$dmarkdown:$dpro"

}