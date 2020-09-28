#!/usr/bin/env bash
# https://github.com/crispgm/dotfiles/blob/master/bootstrap

set -e

echo "Install Homebrew"
if test ! $(which brew); then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Setup hostname"
sudo scutil --set HostName mac

echo "Install from brew.sh"
# bash brew.sh

echo "Install with Brew Bundle"
set +e
brew cleanup
brew uninstall openssl
brew bundle
set -e

echo "Setup workspace"
mkdir -p ~/projects

echo "Setup Git"
ln -s ./git/work.gitconfig ~/projects/.gitconfig
if [ -f $HOME/.gitconfig ]; then
	cat $HOME/.gitconfig
	mv $HOME/.gitconfig $HOME/.gitconfig.bak
fi
ln -s $PWD/git/global.gitconfig $HOME/.gitconfig

# echo "Setup Bash"
# sudo cp ./motd /etc/motd
# cp ./bash/.bashrc ~/.bashrc
# cp ./bash/.bash_profile ~/.bash_profile

echo "Setup Zsh"
sudo sh -c 'echo /usr/local/bin/zsh >> /etc/shells'
sudo chsh -s $(which zsh)
if [ -f ~/.zshrc ]; then
	cat ~/.zshrc
	mv ~/.zshrc ~/zshrc.bak
fi
ln -s $PWD/.zshrc $HOME/.zshrc

echo "Setup Vim"
ln -s $PWD/.vimrc $HOME/.vimrc

echo "Setup Tmux"
ln -s $PWD/tmux/.tmux.conf $HOME/.tmux.conf
ln -s $PWD/tmux/.tmux.conf.local $HOME/.tmux.conf.local

echo "Setup idea vimrc"
ln -s $PWD/idea/.ideavimrc $HOME/.ideavimrc

ls -al $HOME

echo "Setup applications"
echo "- fzf"
$(brew --prefix)/opt/fzf/install
# echo "- neovim"
# ./neovim/neovim

echo "Link editors"
mkdir -p ~/Applications/
sudo ln -s /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/code

# echo "Setup Ruby"
# ./ruby/ruby
# echo "Setup Go"
# mkdir -p ~/go

echo "Setup macOS defaults"
bash init_mac.sh
