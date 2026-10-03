#!/bin/bash
set -e

if command -v dnf >/dev/null; then
    pkg_install() { sudo dnf install -y "$@"; }
elif command -v apt >/dev/null; then
    pkg_install() { sudo apt install -y "$@"; }
else
    echo "No supported package manager (dnf/apt) found" >&2
    exit 1
fi

cd "$(dirname "$0")"

# Copy dotfiles
pkg_install stow git
git submodule update --init
stow .

# Install zsh and plugins
pkg_install zsh
sudo chsh --shell "$(command -v zsh)" "$USER"

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


# Install tmux and plugins using tpm
pkg_install tmux
TPM_PATH=$HOME/.tmux/plugins/tpm
if [ ! -d $TPM_PATH ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
bash ~/.tmux/plugins/tpm/bin/install_plugins
