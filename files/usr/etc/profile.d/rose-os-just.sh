if [ ! -z "$HOME" ] && [ -d "$HOME" ] && [ ! -f "${HOME}/.justfile" ]; then
  cat > "${HOME}/.justfile" << EOF
import "/usr/share/rose-os/justfile"

default:
    @just --list
EOF
fi
