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

  # Check the INHERITED PATH (what the user's interactive shell will see)
  # before we modify our own copy. A stale /usr/bin/nvim (apt) that comes
  # earlier than ~/.local/bin will silently win in the user's shell even
  # though ~/.local/bin is on PATH. Detect that and tell the user how to
  # fix it -- otherwise they re-run nvim, get an old binary, and the
  # script's later prepend masks the problem from any in-script check.
  local inherited_path="${PATH}"
  local stale_apt_nvim=""
  if [[ -x /usr/bin/nvim ]]; then stale_apt_nvim="/usr/bin/nvim"; fi
  local local_bin_pos usr_bin_pos
  local_bin_pos="$(printf '%s\n' "${inherited_path}" | tr ':' '\n' | grep -nx -- "${LOCAL_BIN_DIR}" | head -1 | cut -d: -f1)"
  usr_bin_pos="$(printf '%s\n' "${inherited_path}" | tr ':' '\n' | grep -nx '/usr/bin' | head -1 | cut -d: -f1)"
  local shadow_warning=""
  if [[ -n "${stale_apt_nvim}" ]]; then
    if [[ -z "${local_bin_pos}" ]]; then
      shadow_warning="${LOCAL_BIN_DIR} is not on your interactive shell PATH; ${stale_apt_nvim} will be used instead."
    elif [[ -n "${usr_bin_pos}" ]] && (( local_bin_pos > usr_bin_pos )); then
      shadow_warning="${LOCAL_BIN_DIR} (pos ${local_bin_pos}) comes AFTER /usr/bin (pos ${usr_bin_pos}) on your PATH; ${stale_apt_nvim} will shadow the new nvim."
    fi
  fi

  # Prepend ${LOCAL_BIN_DIR} for the remainder of THIS script so the rest of
  # the install (smoke test, Lazy! sync, mason wait) uses the new binary.
  # This does NOT affect the user's interactive shell.
  export PATH="${LOCAL_BIN_DIR}:${PATH}"
  hash -r 2>/dev/null || true

  if [[ -n "${shadow_warning}" ]]; then
    echo "WARNING: ${shadow_warning}"
    echo "  fix one of:"
    echo "    1. sudo apt remove neovim   (recommended — removes the stale binary)"
    echo "    2. add to ~/.zshrc / ~/.bashrc:  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "  then 'hash -r' or open a new shell. Verify with 'type -a nvim'."
  fi
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
  # `python3-venv` and `python3-pip` are needed so mason can install Python-
  # based tools (flake8, codespell, ruff, debugpy) into per-package venvs.
  # `unzip` + `build-essential` cover mason's archive types and the C
  # compiler that nvim-treesitter parsers need.
  if command -v apt-get >/dev/null 2>&1; then
    echo "installing CLI deps via apt: git ripgrep fd-find curl tar unzip python3 python3-venv python3-pip build-essential"
    sudo apt-get update
    sudo apt-get install -y git ripgrep fd-find curl tar unzip \
      python3 python3-venv python3-pip build-essential
    echo "NOTE: lazygit and JetBrainsMono Nerd Font are not in stock apt repos."
    echo "  lazygit: https://github.com/jesseduffield/lazygit#installation"
    echo "  nerd font: https://github.com/ryanoasis/nerd-fonts/releases (JetBrainsMono.zip)"
  elif command -v dnf >/dev/null 2>&1; then
    echo "installing CLI deps via dnf: git ripgrep fd-find lazygit curl tar unzip python3 python3-pip @development-tools"
    sudo dnf install -y git ripgrep fd-find lazygit curl tar unzip \
      python3 python3-pip @development-tools || true
    echo "NOTE: install JetBrainsMono Nerd Font manually:"
    echo "  https://github.com/ryanoasis/nerd-fonts/releases (JetBrainsMono.zip)"
  else
    echo "WARNING: no supported package manager (apt, dnf); install deps manually:" >&2
    echo "  git, ripgrep, fd, lazygit, curl, tar, unzip, python3-venv, python3-pip, build-essential, JetBrainsMono Nerd Font" >&2
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
NVIM_RESOLVED="$(command -v nvim)"
echo "ok: ${NVIM_VERSION} (>= ${MIN_NVIM_VERSION}) at ${NVIM_RESOLVED}"

# Headless smoke test: confirm the resolved nvim binary can boot with a clean
# environment (no user config, no plugins) before we ask it to bootstrap
# LazyVim. Catches broken downloads, glibc mismatch, or a non-executable
# symlink target with a clear error instead of a cryptic Lua trace.
echo "smoke test: nvim --headless --clean +q"
if ! nvim --headless --clean +q </dev/null >/dev/null 2>&1; then
  echo "ERROR: ${NVIM_RESOLVED} failed to start in --headless --clean mode." >&2
  echo "  rerun manually to see the failure:  nvim --headless --clean +q" >&2
  exit 1
fi
echo "ok: nvim boots cleanly headless"

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

# ---------------------------------------------------------------------------
# 6b. Synchronous mason install
# ---------------------------------------------------------------------------
# `Lazy! sync` above clones every plugin but mason's `ensure_installed` tools
# (stylua, shfmt, shellcheck, codespell, flake8, codelldb, tree-sitter-cli,
# plus LSPs from LazyVim language extras) are kicked off asynchronously and
# get killed when headless nvim exits at `+qa`. Run a second headless step
# that explicitly installs them and waits via vim.wait().
NVIM_MASON_TIMEOUT_MS="${NVIM_MASON_TIMEOUT_MS:-600000}"
# Portable temp file with a .lua suffix: BSD mktemp on macOS does not support
# GNU's `--suffix=`, so create a temp dir and put a named file inside it.
MASON_INSTALL_TMPDIR="$(mktemp -d 2>/dev/null || mktemp -d -t mason-install)"
MASON_INSTALL_LUA="${MASON_INSTALL_TMPDIR}/mason-install.lua"
trap 'rm -rf "${MASON_INSTALL_TMPDIR}"' EXIT
cat >"${MASON_INSTALL_LUA}" <<LUA
local ok, mr = pcall(require, "mason-registry")
if not ok then
  io.stderr:write("mason-registry not available; skipping mason sync\n")
  return
end

local refreshed = false
mr.refresh(function() refreshed = true end)
vim.wait(30000, function() return refreshed end, 250)

local settings_ok, settings = pcall(require, "mason.settings")
local raw = (settings_ok and (settings.current or {}).ensure_installed) or {}
local names = {}
for _, e in ipairs(raw) do
  names[#names + 1] = (type(e) == "table") and e[1] or e
end

if #names == 0 then
  io.write("no mason ensure_installed packages declared\n")
  return
end

io.write(string.format("mason: waiting for %d package(s) (timeout %dms)\n",
  #names, ${NVIM_MASON_TIMEOUT_MS}))

-- Mason's setup() auto-fires ensure_installed at load time, so installs may
-- already be in flight. Only kick off packages that are NOT already queued,
-- and wrap in pcall to tolerate races / API changes.
for _, name in ipairs(names) do
  local pok, pkg = pcall(mr.get_package, name)
  if pok and not pkg:is_installed() then
    local installing = false
    if type(pkg.is_installing) == "function" then
      local iok, val = pcall(pkg.is_installing, pkg)
      installing = iok and val
    end
    if not installing then
      pcall(function() pkg:install() end)
    end
  end
end

-- Give mason a moment to flip is_installing() to true for auto-dispatched
-- ensure_installed packages before we start polling for their completion.
vim.wait(3000, function() return false end, 250)

-- Poll until no package is still installing. is_installing() is the reliable
-- "done" signal — is_installed() can return true while the binary is still
-- being written, leading to false positives.
local done = vim.wait(${NVIM_MASON_TIMEOUT_MS}, function()
  for _, name in ipairs(names) do
    local pok, pkg = pcall(mr.get_package, name)
    if pok and type(pkg.is_installing) == "function" then
      local iok, installing = pcall(pkg.is_installing, pkg)
      if iok and installing then return false end
    end
  end
  return true
end, 1000)

local missing = 0
for _, name in ipairs(names) do
  local pok, pkg = pcall(mr.get_package, name)
  local state = (pok and pkg:is_installed()) and "ok" or "MISSING"
  if state == "MISSING" then missing = missing + 1 end
  io.write(string.format("  %s: %s\n", name, state))
end

if not done then
  io.stderr:write("WARNING: mason install timed out before all packages finished\n")
end
if missing > 0 then
  io.stderr:write(string.format(
    "WARNING: %d mason package(s) still missing; re-run :Mason interactively\n", missing))
end
LUA

echo "running headless: mason ensure_installed (sync wait, up to $((NVIM_MASON_TIMEOUT_MS / 1000))s)"
nvim --headless \
  +"lua require('lazy').load({plugins = {'mason.nvim'}})" \
  -c "luafile ${MASON_INSTALL_LUA}" \
  +qa

# ---------------------------------------------------------------------------
# 7. Post-install verification
# ---------------------------------------------------------------------------
# Confirm under the user config (i.e. the symlinked nvim/ dir) that LazyVim
# is reachable. `Lazy! sync` above would have errored under `set -e` if it
# failed outright, but this gives a positive signal and surfaces silent
# config mistakes (e.g. lazy.nvim cloned but the plugin spec never loaded).
echo "verifying LazyVim loaded under user config..."
if ! nvim --headless \
    "+lua local ok = pcall(require, 'lazy'); if not ok then vim.cmd('cq') end" \
    +qa </dev/null >/dev/null 2>&1; then
  echo "ERROR: 'require(\"lazy\")' failed under user config." >&2
  echo "  inspect: nvim --headless +'lua require(\"lazy\")' +qa" >&2
  exit 1
fi

echo
echo "done. nvim: ${NVIM_VERSION} at ${NVIM_RESOLVED}"
echo "Open nvim and run :checkhealth and :Mason to verify LSPs/linters."
