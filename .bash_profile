if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

. ~/.bashrc

export ELECTRON_OZONE_PLATFORM_HINT=auto
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export XDG_CURRENT_DESKTOP=sway

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
