#!/bin/bash
set -e

echo Now installing package manager configs
sudo cp debian_dotfiles/etc/apt/* /etc/apt

echo Now installing system packages
sudo apt-get -y update
sudo apt-get -y install vim emacs tmux powerline btop wireshark ranger polybar make meson ninja-build cmake i3 powerline-gitstatus pipx gcc g++ python3-pip python3-cogapp libcunit1-dev libncurses-dev pkg-config libbz2-dev liblzma-dev libcunit1 kitty rofi feh libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre2-dev  libevdev-dev uthash-dev libev-dev libx11-xcb-dev xbindkeys

echo Now installing dotfiles
mkdir -p ~/.config
cp debian_dotfiles/dotspacemacs ~/.spacemacs
cp debian_dotfiles/dotbashrc ~/.bashrc
cp debian_dotfiles/dotvimrc ~/.vimrc
cp debian_dotfiles/dotxbindkeysrc ~/.xbindkeysrc
cp debian_dotfiles/dottmux.conf ~/.tmux.conf
cp -r debian_dotfiles/dotconfig/* ~/.config

echo Now installing githooks
cp -r githooks ~/githooks
git config --global core.hooksPath ~/githooks

echo Now installing fonts
sudo cp -r fonts /usr/local/share

echo Now installing extra programs
pipx install pywal16

mkdir tmp
git clone https://github.com/plp13/qman.git tmp/qman
cd tmp/qman && meson setup build && cd build && meson compile && sudo meson install

cd ../..
git clone https://github.com/jonaburg/picom.git picom
cd picom
meson --buildtype=release -Dregex=false . build
ninja -C build
sudo ninja -C build install

git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
git clone https://github.com/dalanicolai/robot-framework-layer.git ~/.emacs.d/private/robot-framework

echo Now installing spacemacs dependencies
yes | emacs --batch -l ~/.emacs.d/init.el

echo Now installing tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new-session -d -s tmp
~/.tmux/plugins/tpm/bindings/install_plugins
tmux kill-session -t tmp
