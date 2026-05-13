#!/usr/bin/env bash
# lazyvim-setup.sh
#
# End-to-end LazyVim install for this dotfiles checkout:
#
#   1. Install CLI dependencies LazyVim relies on (git, ripgrep, fd, lazygit)
#   2. Install JetBrainsMono Nerd Font (macOS via brew cask, Linux: manual)
#   3. Clone lazy.nvim into ~/.local/share/nvim/lazy/lazy.nvim
#      (LazyVim itself is loaded by lazy.nvim as a plugin spec, so this is the
#      "install" step for LazyVim. Upstream has no curl|sh installer.)
#   4. Back up any pre-existing ~/.config/nvim or ~/.config/lvim
#   5. Symlink ~/.config/nvim -> <repo>/nvim
#   6. Run `nvim --headless +'Lazy! sync' +qa` to pull LazyVim and every
#      plugin declared under nvim/lua/plugins/*.lua
#
# Prereq: neovim itself must already be installed (e.g. `brew install neovim`).
# Idempotent: re-running is safe.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${DOTFILES_DIR}/nvim"
DEST="${HOME}/.config/nvim"
LVIM_DIR="${HOME}/.config/lvim"
LAZY_NVIM_DIR="${HOME}/.local/share/nvim/lazy/lazy.nvim"
LAZY_NVIM_REPO="https://github.com/folke/lazy.nvim.git"
STAMP="$(date +%Y%m%d-%H%M%S)"
OS="$(uname -s)"

# ---------------------------------------------------------------------------
# 1+2. OS-specific dependency install
# ---------------------------------------------------------------------------

install_macos_deps() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "WARNING: Homebrew not found; skipping dependency install." >&2
    echo "  install brew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" >&2
    return 0
  fi

  local pkgs=(git ripgrep fd lazygit)
  local missing=()
  for p in "${pkgs[@]}"; do
    command -v "$p" >/dev/null 2>&1 || missing+=("$p")
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "installing CLI deps via brew: ${missing[*]}"
    brew install "${missing[@]}"
  else
    echo "ok: CLI deps already present (git, ripgrep, fd, lazygit)"
  fi

  if brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
    echo "ok: JetBrainsMono Nerd Font already installed"
  else
    echo "installing font-jetbrains-mono-nerd-font cask"
    brew install --cask font-jetbrains-mono-nerd-font || \
      echo "WARNING: Nerd Font install failed; install manually if needed." >&2
  fi
}

install_linux_deps() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "installing CLI deps via apt: git ripgrep fd-find"
    sudo apt-get update
    sudo apt-get install -y git ripgrep fd-find
    echo "NOTE: lazygit and JetBrainsMono Nerd Font are not in stock apt repos."
    echo "  lazygit: https://github.com/jesseduffield/lazygit#installation"
    echo "  nerd font: https://github.com/ryanoasis/nerd-fonts/releases (JetBrainsMono.zip)"
  elif command -v dnf >/dev/null 2>&1; then
    echo "installing CLI deps via dnf: git ripgrep fd-find lazygit"
    sudo dnf install -y git ripgrep fd-find lazygit || true
    echo "NOTE: install JetBrainsMono Nerd Font manually:"
    echo "  https://github.com/ryanoasis/nerd-fonts/releases (JetBrainsMono.zip)"
  else
    echo "WARNING: no supported package manager (apt, dnf); install deps manually:" >&2
    echo "  git, ripgrep, fd, lazygit, JetBrainsMono Nerd Font" >&2
  fi
}

case "${OS}" in
  Darwin) install_macos_deps ;;
  Linux)  install_linux_deps ;;
  *) echo "WARNING: unsupported OS ${OS}; skipping dependency install" >&2 ;;
esac

# ---------------------------------------------------------------------------
# nvim prereq check
# ---------------------------------------------------------------------------

if ! command -v nvim >/dev/null 2>&1; then
  echo "ERROR: neovim not on PATH." >&2
  echo "  install it first (macOS: brew install neovim) and re-run this script." >&2
  exit 1
fi

NVIM_VERSION="$(nvim --version | head -1)"
echo "ok: ${NVIM_VERSION}"

# ---------------------------------------------------------------------------
# 3. Clone lazy.nvim (the LazyVim install step)
# ---------------------------------------------------------------------------

if [[ -d "${LAZY_NVIM_DIR}/.git" ]]; then
  echo "ok: lazy.nvim already cloned at ${LAZY_NVIM_DIR}"
else
  echo "cloning lazy.nvim -> ${LAZY_NVIM_DIR}"
  mkdir -p "$(dirname "${LAZY_NVIM_DIR}")"
  git clone --filter=blob:none --branch=stable "${LAZY_NVIM_REPO}" "${LAZY_NVIM_DIR}"
fi

# ---------------------------------------------------------------------------
# 4+5. Backup and symlink
# ---------------------------------------------------------------------------

if [[ ! -d "${SRC}" ]]; then
  echo "ERROR: ${SRC} does not exist; run from a checkout containing nvim/." >&2
  exit 1
fi

mkdir -p "${HOME}/.config"

backup_if_real() {
  local path="$1"
  if [[ -L "${path}" ]]; then
    local target
    target="$(readlink "${path}")"
    if [[ "${target}" == "${SRC}" ]]; then
      echo "ok: ${path} already symlinked to ${SRC}"
      return 1
    fi
    echo "moving symlink ${path} -> ${target} aside to ${path}.bak.${STAMP}"
    mv "${path}" "${path}.bak.${STAMP}"
  elif [[ -e "${path}" ]]; then
    echo "moving directory ${path} aside to ${path}.bak.${STAMP}"
    mv "${path}" "${path}.bak.${STAMP}"
  fi
  return 0
}

if backup_if_real "${LVIM_DIR}"; then :; fi

if backup_if_real "${DEST}"; then
  ln -s "${SRC}" "${DEST}"
  echo "linked ${DEST} -> ${SRC}"
fi

# ---------------------------------------------------------------------------
# 6. Headless plugin install
# ---------------------------------------------------------------------------

echo "running headless: nvim --headless +'Lazy! sync' +qa"
nvim --headless "+Lazy! sync" +qa

echo
echo "done. Open nvim and run :checkhealth and :Mason to verify."
