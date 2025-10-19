#!/bin/bash
set -e

echo Now installing package manager configs
sudo cp debian_dotfiles/etc/apt/* /etc/apt

echo Now installing system packages
sudo apt-get -y update
sudo apt-get -y install vim emacs tmux powerline btop wireshark ranger polybar make meson ninja-build cmake i3 powerline-gitstatus pipx gcc g++ python3-pip python3-cogapp libcunit1-dev libncurses-dev pkg-config libbz2-dev liblzma-dev libcunit1 kitty rofi feh

echo Now installing dotfiles
cp debian_dotfiles/dotspacemacs ~/.spacemacs
cp debian_dotfiles/dotbashrc ~/.bashrc
cp debian_dotfiles/dotvimrc ~/.vimrc
cp debian_dotfiles/dottmux.conf ~/.tmux.conf
cp -r debian_dotfiles/dotconfig/* ~/.config

echo Now installing fonts
sudo cp -r fonts /usr/local/share

echo Now installing extra programs
pipx install pywal16

mkdir -p tmp
git clone https://github.com/plp13/qman.git tmp/qman
cd tmp/qman && meson setup build && cd build && meson compile && sudo meson install

git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
git clone https://github.com/dalanicolai/robot-framework-layer.git ~/.emacs.d/private/robot-framework

echo Now installing spacemacs dependencies
yes | emacs --batch -l ~/.emacs.d/init.el

echo Now installing tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new-session -d -s tmp
~/.tmux/plugins/tpm/bindings/install_plugins
tmux kill-session -t tmp
