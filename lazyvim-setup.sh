#!/usr/bin/env bash
# lazyvim-setup.sh
#
# End-to-end LazyVim install for this dotfiles checkout:
#
#   1. Install CLI dependencies LazyVim relies on (git, ripgrep, fd, lazygit)
#   2. Install JetBrainsMono Nerd Font (macOS via brew cask, Linux: manual)
#   3. On Linux: install latest neovim from upstream tarball if missing or
#      below MIN_NVIM_VERSION (stock apt on Ubuntu ships an old release).
#      On macOS: neovim is expected via `brew install neovim`.
#   4. Clone lazy.nvim into ~/.local/share/nvim/lazy/lazy.nvim
#      (LazyVim itself is loaded by lazy.nvim as a plugin spec, so this is the
#      "install" step for LazyVim. Upstream has no curl|sh installer.)
#   5. Back up any pre-existing ~/.config/nvim or ~/.config/lvim
#   6. Symlink ~/.config/nvim -> <repo>/nvim
#   7. Run `nvim --headless +'Lazy! sync' +qa` to pull LazyVim and every
#      plugin declared under nvim/lua/plugins/*.lua
#
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

# LazyVim currently requires neovim >= 0.11.2 (built with LuaJIT).
MIN_NVIM_VERSION="0.11.2"
NVIM_RELEASE_DIR="${HOME}/.local/share/nvim-release"
LOCAL_BIN_DIR="${HOME}/.local/bin"

# Return 0 if `nvim` is on PATH and >= MIN_NVIM_VERSION, else non-zero.
nvim_version_ok() {
  command -v nvim >/dev/null 2>&1 || return 1
  local current
  current="$(nvim --version 2>/dev/null | head -1 \
    | sed -nE 's/^NVIM v([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')"
  [[ -n "${current}" ]] || return 1
  local highest
  highest="$(printf '%s\n%s\n' "${MIN_NVIM_VERSION}" "${current}" | sort -V | tail -1)"
  [[ "${highest}" == "${current}" ]]
}

# Install latest neovim from upstream release tarball into ~/.local/share/...
# and symlink the binary into ~/.local/bin/nvim. Used on Linux because stock
# distro packages (notably Ubuntu's) lag well behind LazyVim's requirement.
install_latest_nvim_linux() {
  local arch nvim_arch tarball url tmp
  arch="$(uname -m)"
  case "${arch}" in
    x86_64|amd64)   nvim_arch="x86_64" ;;
    aarch64|arm64)  nvim_arch="arm64" ;;
    *)
      echo "WARNING: unsupported architecture '${arch}' for upstream nvim tarball;" >&2
      echo "  install neovim >= ${MIN_NVIM_VERSION} manually and re-run." >&2
      return 1
      ;;
  esac

  if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: curl is required to download neovim from GitHub releases." >&2
    return 1
  fi

  tarball="nvim-linux-${nvim_arch}.tar.gz"
  url="https://github.com/neovim/neovim/releases/latest/download/${tarball}"

  mkdir -p "${LOCAL_BIN_DIR}"
  tmp="$(mktemp -d)"
  # shellcheck disable=SC2064
  trap "rm -rf '${tmp}'" RETURN

  echo "downloading latest neovim (${nvim_arch}) from ${url}"
  curl -fL --progress-bar "${url}" -o "${tmp}/${tarball}"

  rm -rf "${NVIM_RELEASE_DIR}"
  mkdir -p "${NVIM_RELEASE_DIR}"
  tar -xzf "${tmp}/${tarball}" -C "${NVIM_RELEASE_DIR}" --strip-components=1

  ln -sf "${NVIM_RELEASE_DIR}/bin/nvim" "${LOCAL_BIN_DIR}/nvim"
  echo "installed neovim -> ${NVIM_RELEASE_DIR} (symlinked ${LOCAL_BIN_DIR}/nvim)"

  if ! echo ":${PATH}:" | grep -q ":${LOCAL_BIN_DIR}:"; then
    echo "NOTE: ${LOCAL_BIN_DIR} is not on PATH for this shell."
    echo "  add to your shell rc:  export PATH=\"\$HOME/.local/bin:\$PATH\""
    # Prepend for the remainder of this script so the prereq check picks it up.
    export PATH="${LOCAL_BIN_DIR}:${PATH}"
  fi
  hash -r 2>/dev/null || true
}

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
    echo "installing CLI deps via apt: git ripgrep fd-find curl tar"
    sudo apt-get update
    sudo apt-get install -y git ripgrep fd-find curl tar
    echo "NOTE: lazygit and JetBrainsMono Nerd Font are not in stock apt repos."
    echo "  lazygit: https://github.com/jesseduffield/lazygit#installation"
    echo "  nerd font: https://github.com/ryanoasis/nerd-fonts/releases (JetBrainsMono.zip)"
  elif command -v dnf >/dev/null 2>&1; then
    echo "installing CLI deps via dnf: git ripgrep fd-find lazygit curl tar"
    sudo dnf install -y git ripgrep fd-find lazygit curl tar || true
    echo "NOTE: install JetBrainsMono Nerd Font manually:"
    echo "  https://github.com/ryanoasis/nerd-fonts/releases (JetBrainsMono.zip)"
  else
    echo "WARNING: no supported package manager (apt, dnf); install deps manually:" >&2
    echo "  git, ripgrep, fd, lazygit, curl, JetBrainsMono Nerd Font" >&2
  fi

  # Stock Linux distros (Ubuntu in particular) ship a neovim too old for
  # current LazyVim. Install / upgrade from the upstream release tarball.
  if nvim_version_ok; then
    echo "ok: neovim already >= ${MIN_NVIM_VERSION}: $(nvim --version | head -1)"
  else
    if command -v nvim >/dev/null 2>&1; then
      echo "neovim present but < ${MIN_NVIM_VERSION} ($(nvim --version | head -1)); upgrading from upstream"
    else
      echo "neovim not installed; installing latest from upstream"
    fi
    install_latest_nvim_linux
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

if ! nvim_version_ok; then
  echo "ERROR: nvim is below required minimum ${MIN_NVIM_VERSION}:" >&2
  nvim --version | head -1 >&2
  echo "  on Linux this script auto-installs latest; on macOS run: brew upgrade neovim" >&2
  exit 1
fi

NVIM_VERSION="$(nvim --version | head -1)"
echo "ok: ${NVIM_VERSION} (>= ${MIN_NVIM_VERSION})"

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
