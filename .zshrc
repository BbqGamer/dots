# Theme
if [[ -d $HOME/.zsh/pure ]]; then
    fpath+=($HOME/.zsh/pure)
    autoload -U promptinit; promptinit
    prompt pure
fi

# Completions
fpath=(~/repos/zsh-completions/src $fpath)
autoload -U compinit; compinit

# Allow sh like reverse search
bindkey -v
bindkey '^R' history-incremental-search-backward

#Environment variables
HISTSIZE=1000000
HISTFILE="$HOME/.zsh/zsh_history"
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # Case insensitive match

export PATH=/usr/local/bin:/usr/bin:/bin:~/.local/bin
export FZF_DEFAULT_OPTS='--color=bg+:#5e81ac,gutter:-1,pointer:#d8dee9'
export XDG_CURRENT_DESKTOP=sway
export EDITOR=vim

# Enable colors in man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-R

# Enable vi key bindings
bindkey -v

# Ctrl+Arrows navigation
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Simple aliases
alias open=xdg-open
alias manpy='f() { python3 -c "help($1)" };f'
alias calc='speedcrunch'
alias cls='clear'
alias cz='chezmoi'
alias t='todo.sh'
alias gpt='terminalgpt'
alias ssh='TERM=xterm-256color ssh'
alias c='selected=$(find ~ -maxdepth 3 -type d | fzf) && cd $selected'
alias d='selected=$(find -maxdepth 3 -type d | fzf) && cd $selected'
alias ez='$EDITOR ~/.zshrc && source ~/.zshrc'
alias so='source ~/.zshrc'

# Alias if you forget sudo for basic commands
alias \
	shutdown="sudo shutdown" \
	reboot="sudo reboot" \
	mount="sudo mount" \
	umount="sudo umount" 

# Activate coloring wherever you can
alias \
	ls="ls -hN --color=auto --group-directories-first" \
	grep="grep --color=auto" \
	diff="diff --color=auto" \
	ccat="highlight --out-format=ansi" \
	ip="ip -color=auto" \
	jq="jq -C" \
    ipython="ipython --TerminalInteractiveShell.editing_mode=vi"
    

export BAT_THEME="Nord" 

# plugins
AUTOSUGGESTIONS=$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f $AUTOSUGGESTIONS ]] && source $AUTOSUGGESTIONS
SYNTAX_HIGHLIGHTING=$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f $SYNTAX_HIGHLIGHTING ]] && source $SYNTAX_HIGHLIGHTING

[[ -f $HOME/.config/aliases  ]] && source $HOME/.config/aliases
[[ -f $HOME/.config/zsh-local ]] && source $HOME/.config/zsh-local 

[[ -f venv/bin/activate ]] && source venv/bin/activate

export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
pyenv() {
    # this is made so pyenv doesn't slow down zsh startup
    # https://github.com/pyenv/pyenv/issues/2918#issuecomment-1977029534
    eval "$(command pyenv init -)"
    pyenv "$@"
}

eval "$(direnv hook zsh)"
