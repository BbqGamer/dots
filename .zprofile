#export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
export PATH=${PATH}:~/go/bin:/usr/games
export ANKI_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export PROJECT_PATHS=~/6sem

# >>> coursier install directory >>>
export PATH="$PATH:/home/adam/.local/share/coursier/bin"
# <<< coursier install directory <<<

if [[ -z $WAYLAND_DISPLAY && -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
  exec sway
fi
