#!/bin/bash
# Set up dotfiles on a new machine.
#   ./install.sh              stow dotfiles, zsh + plugins, tmux
#   ./install.sh --packages   also install packages/{pacman,aur,flatpak}.txt (Arch)
set -e

cd "$(dirname "$0")"

list() { grep -vE '^\s*(#|$)' "$1" | sed 's/\s*#.*//'; }

if command -v pacman >/dev/null; then
    pkg_install() { sudo pacman -S --needed --noconfirm "$@"; }
elif command -v dnf >/dev/null; then
    pkg_install() { sudo dnf install -y "$@"; }
elif command -v apt >/dev/null; then
    pkg_install() { sudo apt install -y "$@"; }
else
    echo "No supported package manager (pacman/dnf/apt) found" >&2
    exit 1
fi

if [ "${1:-}" = "--packages" ]; then
    command -v pacman >/dev/null || { echo "--packages is Arch-only" >&2; exit 1; }
    sudo pacman -Syu --noconfirm
    # install what exists in the repos, report the rest instead of failing
    available=$(pacman -Slq | sort -u)
    wanted=$(list packages/pacman.txt | sort -u)
    missing=$(comm -23 <(echo "$wanted") <(echo "$available"))
    pkg_install $(comm -12 <(echo "$wanted") <(echo "$available"))
    [ -z "$missing" ] || echo "Not in official repos (check names): $missing"

    if ! command -v paru >/dev/null; then
        # built from source: paru-bin breaks whenever libalpm bumps its soname
        rustup default stable    # cargo comes from rustup (pacman.txt)
        tmp=$(mktemp -d)
        git clone https://aur.archlinux.org/paru.git "$tmp/paru"
        (cd "$tmp/paru" && makepkg -si --noconfirm)
        rm -rf "$tmp"
    fi
    # one at a time so a single broken AUR package doesn't block the rest
    failed=()
    for p in $(list packages/aur.txt); do
        paru -S --needed "$p" || failed+=("$p")
    done
    [ ${#failed[@]} -eq 0 ] || echo "AUR packages that failed: ${failed[*]}"

    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub $(list packages/flatpak.txt)
fi

# Copy dotfiles
pkg_install stow git
git submodule update --init
stow .

# Install zsh and plugins
pkg_install zsh
[ "$(getent passwd "$USER" | cut -d: -f7)" = "$(command -v zsh)" ] || sudo chsh --shell "$(command -v zsh)" "$USER"

mkdir -p ~/.zsh

PLUGIN_PATH=$HOME/.zsh

# Pure is vendored in this repo at .zsh/pure and stowed into ~/.zsh/pure.
AUTOSUGG_PATH=$PLUGIN_PATH/zsh-autosuggestions
if [ ! -d $AUTOSUGG_PATH ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $AUTOSUGG_PATH
fi

SYNTAX_PATH=$PLUGIN_PATH/zsh-syntax-highlighting
if [ ! -d $SYNTAX_PATH ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $SYNTAX_PATH
fi


# tmux (.tmux.conf uses no plugins)
pkg_install tmux
