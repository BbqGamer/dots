#!/bin/bash

# Copy dotfiles
sudo apt install stow
stow .

# Install zsh and plugins
sudo apt install zsh
sudo chsh --shell /bin/zsh $USER

mkdir -p ~/.zsh

PLUGIN_PATH=$HOME/.zsh

THEME_PATH=$PLUGIN_PATH/pure
if [ ! -d $THEME_PATH ]; then
    git clone https://github.com/sindresorhus/pure.git $THEME_PATH
fi

AUTOSUGG_PATH=$PLUGIN_PATH/zsh-autosuggestions
if [ ! -d $AUTOSUGG_PATH ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $AUTOSUGG_PATH
fi

SYNTAX_PATH=$PLUGIN_PATH/zsh-syntax-highlighting
if [ ! -d $SYNTAX_PATH ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $SYNTAX_PATH
fi


# Install tmux and plugins using tpm
sudo apt install tmux
TPM_PATH=$HOME/.tmux/plugins/tpm
if [ ! -d $TPM_PATH ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
bash ~/.tmux/plugins/tpm/bin/install_plugins
