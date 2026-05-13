#!/usr/bin/env bash
# lazyvim-setup.sh
#
# Symlinks ~/.config/nvim -> <repo>/nvim, backing up any pre-existing
# ~/.config/nvim and ~/.config/lvim directories, then runs a headless
# `Lazy! sync` to install plugins.
#
# Idempotent: re-running is safe. Existing real directories are renamed
# with a timestamp suffix; existing correct symlinks are left alone.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${DOTFILES_DIR}/nvim"
DEST="${HOME}/.config/nvim"
LVIM_DIR="${HOME}/.config/lvim"
STAMP="$(date +%Y%m%d-%H%M%S)"

if [[ ! -d "${SRC}" ]]; then
  echo "ERROR: ${SRC} does not exist. Run from a checkout that contains nvim/." >&2
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

if backup_if_real "${LVIM_DIR}"; then
  :
fi

if backup_if_real "${DEST}"; then
  ln -s "${SRC}" "${DEST}"
  echo "linked ${DEST} -> ${SRC}"
fi

if ! command -v nvim >/dev/null 2>&1; then
  echo "WARNING: nvim not on PATH. Install neovim and re-run to sync plugins." >&2
  exit 0
fi

echo "running headless: nvim --headless +'Lazy! sync' +qa"
nvim --headless "+Lazy! sync" +qa

echo
echo "done. Open nvim and run :checkhealth to verify."
