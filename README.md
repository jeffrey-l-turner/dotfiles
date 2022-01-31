#dotfiles.git
============

Now using `zsh` instead of `bash`. No longer supporting emacs in favor of LunarVim

## On MacOS:
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
```
brew tap homebrew/cask-fonts
brew install stow fzf zsh font-meslo-nerd-font font-arimo-nerd-font font-jetbrains-mono-nerd-font font-jetbrains-mono font-fira-code-nerd-font font-blex-mono-nerd-font font-lekton-nerd-font font-liberation-nerd-font neovim rlwrap spellcheck shellcheck wget git python python3 gawk java gpgconf gpg rustup rustup-init cmake ripgrep fd
```
```
# after installing [node/nvm](https://github.com/nvm-sh/nvm) (any system):
npm i -g lib language-server bash-language-server create-next-pwa eslint_d eslint expo-cli fixjson hardhat-shorthand neovim npm prettier shellcheck solhint-plugin-prettier solhint tree-sitter-cli yarn
```
============

Clone and run this on  new instances for headless/interactive setup, Windows, *nix, or MAC OS to
configure `ssh`, `bash`, `zsh`, `node`, and `lvim` development environment as follows:

```sh
mkdir ~/src
cd ~/src
git clone git@github.com:jeffrey-l-turner/dotfiles.git
ln -sb dotfiles/.screenrc ~
ln -sb dotfiles/.vimrc  ~
ln -sb dotfiles/.z*  ~
ln -sb dotfiles/.jshintrc  ~
ln -sb dotfiles/.eslintrc  ~
ln -sb dotfiles/.git_template  ~
cat dotfiles/ssh-config-* >> ~/.ssh/config
nvm current > ~/.nvmrc
```


See also [syssetup](http://github.com/jeffrey-l-turner/syssetup) to install prerequisite programs. If all goes well, in addition to a eternal history on zsh, these files may
be used to setup headless systems. The macOS-defaults configures a Mac from the command line.  This was originally developed for
[Startup Engineering Lectures](https://class.coursera.org/) and adapted from `bash` to `zsh`.


