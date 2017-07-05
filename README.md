dotfiles.git
============
Clone and run this on  new instances for headless/interactive setup, Windows, *nix, or MAC OS to
configure `ssh`, `bash`, `node`, `vim`, and `emacs` development environment as follows:

```sh
git clone https://github.com/jeffrey-l-turner/dotfiles.git
ln -sb dotfiles/.screenrc ~
ln -sb dotfiles/.bash_profile ~
ln -sb dotfiles/.bashrc ~
ln -sb dotfiles/.bashrc_custom ~
ln -sb dotfiles/.bash_logout  ~
ln -sb dotfiles/.vimrc  ~
ln -sb dotfiles/.jshintrc  ~
ln -sb dotfiles/.eslintrc  ~
ln -sb dotfiles/.ctags  ~
ln -sb dotfiles/.tidy  ~
ln -sb dotfiles/.git_template  ~
mv dotfiles/.emacs.d ~/.emacs.d~
ln -s dotfiles/.emacs.d ~
cat dotfiles/ssh-config-* >> ~/.ssh/config
dotfiles/.git_template/config.sh # to set git hooks for tagging, etc.
```

See also http://github.com/jeffrey-l-turner/syssetup to install prerequisite programs. If all goes well, in addition to a more useful prompt, these files may
be used to setup many different headless systems. The macOS-defaults configures a Mac from the command line.  This was originally developed for [Startup Engineering Lectures](https://class.coursera.org/).
