

# ─── 42 ──────────────────────────────────────────────────────────────

path_42(){

    export dproject="$HOME/project"                                         # project
        export dcpp0="$dproject/CPP_00"                                     # ├── CPP_00
        export dcpp2="$dproject/CPP_02"                                     # ├── CPP_02
        export dcpp5="$dproject/CPP_05"                                     # ├── CPP_05
        export dcpp7="$dproject/CPP_07"                                     # ├── CPP_07
        export dcpp8="$dproject/CPP_08"                                     # ├── CPP_08
        export dcpp9="$dproject/CPP_09"                                     # ├── CPP_09
        export dformation_extern="$HOME/project/formation_extern"           # ├── formation_extern
            export dmatrix="$dformation_extern/Extensions_Matrix_42lyon"    # │   ├── Extensions_Matrix_42lyon
            export dhtml="$dformation_extern/HTML_CSS"                      # │   ├── HTML_CSS
            export djavescript="$dformation_extern/JavaScript"              # │   ├── JavaScript
            export dmarkdown="$dformation_extern/Markdown"                  # │   ├── Markdown
            export dpro="$dformation_extern/Portfolio"                      # │   ├── Portfolio
            export dreact="$dformation_extern/React"                        # │   ├── React
            export dtypescript="$dformation_extern/TypeScript"              # │   └── TypeScript
        export dtranscendence="$dproject/ft_transcendence/web"              # ├── ft_transcendence
            export dback="$dtranscendence/back/src"                         # │   ├── "..."
            export dfront="$dtranscendence/front"                           # │   ├── "..."
            export dpage="$dfront/src/page"                                 # │   ├── "..."
            export dstyle="$dfront/src/style"                               # │   ├── "..."
            export fborder="$dfront/src/style/global/border.scss"           # │   └── "..."
        export dlibasm="$dproject/libasm"                                   # ├── libasm
        export dlibft="$dproject/libft"                                     # ├── libft
        export dwebserve="$dproject/webserv"                                # └── webserv

    export GIT_PATH_42="$dcpp0:$dcpp2:$dcpp5:$dcpp7:$dcpp8:$dcpp9:$dformation_extern\
:$dhtml:$djavescript:$dmarkdown:$dpro:$dreact:$dtypescript:$dtranscendence/..:$dlibasm:$dlibft:$dwebserve"

}


# ─── Maison ──────────────────────────────────────────────────────────────

path_maison(){

    export dproject="$HOME/project"                                     # project
        export dtranscendence="$dproject/ft_transcendence/web"          # ├── ft_transcendence
        export ddotfile="$dproject/LzozoFlo"                            # ├── LzozoFlo
        export dmarkdown="$dproject/Markdown"                           # ├── Markdown
        export dportfolio="$dproject/portfolio"                         # └── portfolio
            export dpro="$dportfolio/Portfolio"                         #     ├── Portfolio    branch : main
            export dpro="$dportfolio/readme"                            #     └── readme       branch : site_file

    export GIT_PATH_MAISON="$dproject:$dtranscendence:$ddotfile:$dmarkdown:$dpro"

}