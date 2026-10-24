#!/bin/sh
set -eu

base_repo="${CHEZMOI_REPO_URL:-https://github.com/404ALegend/mac-dots.git}"
source_dir="$HOME/.local/share/chezmoi"

log() {
  printf '\n==> %s\n' "$*"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

link_mise_tool() {
  tool="$1"
  if ! need_cmd "$tool"; then
    tool_path="$(mise which "$tool" 2>/dev/null || true)"
    if [ -n "$tool_path" ]; then
      ln -sf "$tool_path" "$HOME/.local/bin/$tool"
    fi
  fi

  if ! need_cmd "$tool"; then
    echo "missing required tool after mise install: $tool" >&2
    exit 1
  fi
}

mkdir -p "$HOME/.local/bin"
PATH="$HOME/.local/bin:$PATH"
export PATH

log "Installing Mise if missing"
if ! need_cmd mise; then
  curl https://mise.run | sh
  PATH="$HOME/.local/bin:$PATH"
  export PATH
fi

if ! need_cmd mise; then
  cat >&2 <<'EOF'
mise installation completed, but mise is not on PATH.
Expected ~/.local/bin/mise. Add ~/.local/bin to PATH and run this script again.
EOF
  exit 1
fi

log "Installing Chezmoi"
mise install chezmoi
mise reshim || true
link_mise_tool chezmoi

log "Initializing Chezmoi source"
if [ ! -d "$source_dir/.git" ]; then
  chezmoi init "$base_repo"
else
  echo "chezmoi source already exists at $source_dir; reusing it" >&2
fi

log "Applying dotfiles"
chezmoi apply

log "Bootstrap complete"
