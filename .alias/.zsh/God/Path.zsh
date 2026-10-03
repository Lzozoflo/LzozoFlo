path(){
    export dproject="$HOME/Project"                                         # project
                                                                            # │
    export d42cc="$dproject/42_cc"                                          # ├── 42_cc
        export allcc=""                                                     # │   │
                                                                            # │   │
        export dlibft="$d42cc/libft"                                        # │   ├── libft
        export dtranscendence="$d42cc/ft_transcendence/web"                 # │   ├── ft_transcendence
        export allcc=$allcc:$dlibft:$dtranscendence                         # │   │
                                                                            # │   ├── milestone__1
            export dft_printf="$d42cc/milestone_1/ft_printf"                # │   │   ├── ft_printf
            export dgetnextline="$d42cc/milestone_1/get_next_line"          # │   │   └── get_next_line
        export allcc=$allcc:$dft_printf:$dgetnextline                       # │   │
                                                                            # │   ├── milestone__2
            export dfractol="$d42cc/milestone_2/ft_fractol"                 # │   │   ├── ft_fractol
            export dpipex="$d42cc/milestone_2/Pipex"                        # │   │   ├── Pipex
            export dpush_swap="$d42cc/milestone_2/push_swap"                # │   │   └── push_swap
        export allcc=$allcc:$dfractol:$dpipex:$dpush_swap                   # │   │
                                                                            # │   ├── milestone__3
            export dminishell="$d42cc/milestone_3/Minishell"                # │   │   ├── Minishell
            export dphilo="$d42cc/milestone_3/philosophers"                 # │   │   └── philosophers
        export allcc=$allcc:$dminishell:$dphilo                             # │   │
                                                                            # │   ├── milestone__4
                                                                            # │   │   ├── cpp
                export dcpp0="$d42cc/milestone_4/cpp/CPP_00"                # │   │   │   ├── CPP_00
                export dcpp1="$d42cc/milestone_4/cpp/CPP_01"                # │   │   │   ├── CPP_01
                export dcpp2="$d42cc/milestone_4/cpp/CPP_02"                # │   │   │   ├── CPP_02
                export dcpp3="$d42cc/milestone_4/cpp/CPP_03"                # │   │   │   ├── CPP_03
                export dcpp4="$d42cc/milestone_4/cpp/CPP_04"                # │   │   │   └── CPP_04
            export dcub3D="$d42cc/milestone_4/Cub3D"                        # │   │   └── Cub3D
        export allcc=$allcc:$dcpp0:$dcpp1:$dcpp2:$dcpp3:$dcpp4:$dcub3D      # │   │
                                                                            # │   │
                                                                            # │   └── milestone__5
                                                                            # │       ├── cpp
                export dcpp5="$d42cc/milestone_5/cpp/CPP_05"                # │       │   ├── CPP_05
                export dcpp6="$d42cc/milestone_5/cpp/CPP_06"                # │       │   ├── CPP_06
                export dcpp7="$d42cc/milestone_5/cpp/CPP_07"                # │       │   ├── CPP_07
                export dcpp8="$d42cc/milestone_5/cpp/CPP_08"                # │       │   ├── CPP_08
                export dcpp8="$d42cc/milestone_5/cpp/CPP_09"                # │       │   └── CPP_09
            export dinception="$d42cc/milestone_5/inception"                # │       ├── Inception
            export dwebserve="$d42cc/milestone_5/webserve"                  # │       └── webserv
        export allcc=$allcc:$dcpp5:$dcpp6:$dcpp7:$dcpp8:$dcpp9              # │
        export allcc=$allcc:$dinception:$dwebserve                          # │
                                                                            # │
    export d42postcc="$dproject/42_cc"                                      # ├── 42_post_cc
                                                                            # │   │
                                                                            # │   ├── piscine
    export dpythondata="$d42postcc/piscine/Python_for_Data_Science"         # │   │   └── Python_for_Data_Science
                                                                            # │   ├── rush
    export dshmup="$d42postcc/rush/ft_shmup"                                # │   │   └── ft_shmup
                                                                            # │   │
    export davaj="$d42postcc/avaj-luncher"                                  # │   ├── avaj-luncher
    export dping="$d42postcc/ft_ping"                                       # │   ├── ft_ping
    export dlibasm="$d42postcc/libasm"                                      # │   ├── libasm
    export dsnow="$d42postcc/SnowCrash"                                     # │   └── SnowCrash
                                                                            #

        export allpostcc="$d42postcc"                                       # │   │
        export allcc=""                                                     # │   │

    export GIT_PATH_42=$allcc:$allpostcc

}
