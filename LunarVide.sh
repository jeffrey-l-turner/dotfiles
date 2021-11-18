#!/usr/bin/env bash
# copy neovide to LunarVide in ~/local/bin to setup App

export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-~/.local/share/lunarvim/lvim}"
export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-~/.local/bin/lunarvim}"

# osx must use stty -g
if [ "${OS}" = "darwin" ]; then
  TTYOPTS="$(stty -g)"
else
  TTYOPTS="$(stty --save)"
fi
stty  stop '' -ixoff
command neovide --frameless --maximized -- -u "$LUNARVIM_RUNTIME_DIR/lvim/init.lua" "$@"
stty  "$TTYOPTS"
