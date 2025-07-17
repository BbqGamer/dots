if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

. ~/.bashrc

export ELECTRON_OZONE_PLATFORM_HINT=auto

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
