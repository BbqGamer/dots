
. ~/.bashrc

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/adam/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/adam/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
