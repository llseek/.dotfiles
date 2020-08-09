#!/usr/bin/env bash

ZTV_ROOT=$PWD

if [ `uname -s` == 'Darwin' ]; then
  PKG_INSTALL='brew install'
  FIREFOX_PROFILE='Library/Application\ Support/Firefox/Profiles'
else
  PKG_INSTALL='sudo apt -y install'
  FIREFOX_PROFILE='.mozilla/firefox'
fi

git config user.email "yxj@gmail.com"
git config user.name "Xiaojie Yuan"
git config core.editor vim
git config push.default simple
git config --global core.excludesfile '~/.gitignore'
git config --global rebase.instructionformat "[%an] %s"

cd $HOME

$PKG_INSTALL git                \
             zsh                \
             tmux               \
             vim                \
             ctags              \
             global             \
             curl

if [ ! -d .oh-my-zsh ]; then
	git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh || exit
fi

cp $ZTV_ROOT/llseek.zsh-theme ./.oh-my-zsh/themes/

echo "Enter your sudo passwd to chsh: "
chsh -s `which zsh`

for f in .zshrc .tmux.conf .vimrc .ssh .gitignore; do
  [ -f $f -o -d $f ] && mv $f $f.old
  ln -s $ZTV_ROOT/$f
done

vim +PlugInstall +qall

echo '    StrictHostKeyChecking no' | sudo tee -a /etc/ssh/ssh_config
echo '    UserKnownHostsFile /dev/null' | sudo tee -a /etc/ssh/ssh_config

sudo cp $ZTV_ROOT/fonts/* /usr/share/fonts
sudo fc-cache -f

if [ -d "$FIREFOX_PROFILE" ]; then
  d=$(ls -d "$FIREFOX_PROFILE"/*default*)
  mkdir -p "$d"/chrome
  cp $ZTV_ROOT/firefox/userChrome.css "$d"/chrome
  echo "Firefox's userChrome.css: $d/chrome/userChrome.css"
fi

echo "Asia/Shanghai" | sudo tee /etc/timezone
