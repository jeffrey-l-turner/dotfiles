dotfiles.git
============
Clone and run this on a new instances or MAC OS to
configure `ssh`, `bash`, `node`, and `emacs` development environment as follows:

```sh
cd $HOME
git clone https://github.com/jeffrey-l-turner/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sb dotfiles/.bash_logout .
ln -sb dotfiles/.vimrc
mv .emacs.d .emacs.d~
ln -s dotfiles/.emacs.d .
cat dotfiles/ssh-config-* >> ~/.ssh/config
```

See also http://github.com/jeffrey-l-turner/syssetup to install prerequisite
programs. If all goes well, in addition to a more useful prompt, now you can
do `emacs -nw hello.js` and hitting `C-c!` to launch an interactive SSJS
REPL, among many other features. This was originally developed for
[Startup Engineering Video Lectures 4a/4b](https://class.coursera.org/startup-001/lecture/index).
