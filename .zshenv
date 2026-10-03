[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Cap pytest-xdist "-n auto" so parallel worktree suites don't OOM the laptop
export PYTEST_XDIST_AUTO_NUM_WORKERS=4

# Extra intermediate CA for a work server that sends an incomplete chain
export NODE_EXTRA_CA_CERTS="$HOME/.local/share/certs/homepl-r35.pem"
