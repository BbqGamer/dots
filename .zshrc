[[ -o interactive ]] || return

setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_SPACE HIST_IGNORE_ALL_DUPS HIST_VERIFY
setopt INTERACTIVE_COMMENTS NO_NOMATCH

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=20000000

if [[ -z "${debian_chroot:-}" && -r /etc/debian_chroot ]]; then
    debian_chroot="$(</etc/debian_chroot)"
fi

fpath=(
    "$HOME/.zsh/completions"
    "$HOME/.zsh/plugins/zsh-completions/src"
    $fpath
)

autoload -Uz colors compinit
colors
if [[ -n ${ZSH_COMPDUMP:-} ]]; then
    compinit -d "$ZSH_COMPDUMP"
else
    compinit
fi

bindkey -v
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M vicmd '^R' history-incremental-search-backward

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

c() {
    local selected
    selected=$(find ~ -maxdepth 3 -type d 2> /dev/null | fzf) || return
    [[ -n "$selected" ]] && cd "$selected"
}

d() {
    local selected
    selected=$(find -maxdepth 3 -type d 2> /dev/null | fzf) || return
    [[ -n "$selected" ]] && cd "$selected"
}

o() {
    local selected
    selected=$(find -maxdepth 4 -type f 2> /dev/null | fzf) || return
    [[ -n "$selected" ]] && xdg-open "$selected"
}

gco() {
    local selected type branch
    selected=$( {
        git for-each-ref --format='local	%(refname:short)' refs/heads
        git for-each-ref --format='remote	%(refname:short)' refs/remotes | grep -v '/HEAD$'
    } | fzf --height 40% --reverse --delimiter=$'\t' --with-nth=2.. --prompt='branch> ' \
        --preview 'git log --oneline --decorate --graph --max-count=12 --color=always {2}' \
        --preview-window=right:60%) || return

    IFS=$'\t' read -r type branch <<<"$selected"

    case "$type" in
        remote) git switch --track -c "${branch#*/}" "$branch" ;;
        *)      git switch "$branch" ;;
    esac
}

export EDITOR=vim
export FZF_DEFAULT_OPTS='--color=bg+:#5e81ac,gutter:-1,pointer:#d8dee9'

if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

path=("$HOME/.opencode/bin" "$HOME/.cargo/bin" $path)
export PATH

# pure prompt
if [[ -d "$HOME/.zsh/pure" ]]; then
    fpath+=("$HOME/.zsh/pure")

    PURE_PROMPT_SYMBOL=">"
    PURE_PROMPT_VICMD_SYMBOL="<"

    autoload -U promptinit; promptinit
    prompt pure
fi


[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/adam/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
