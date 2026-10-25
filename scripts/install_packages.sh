#!/usr/bin/env bash
set -euo pipefail

#echo Now installing package manager configs
#sudo cp debian_dotfiles/etc/apt/* /etc/apt

echo "Pre-installing base utils"
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-utils \
    bash \
    bash-completion \
    bc \
    bzip2 \
    curl \
    dialog \
    diffutils \
    findutils \
    gnupg \
    gnupg2 \
    gpgsm \
    hostname \
    iproute2 \
    iputils-ping \
    keyutils \
    less \
    libcap2-bin \
    libegl-mesa0 \
    libegl1 \
    libgl1 \
    libglx-mesa0 \
    libkrb5-3 \
    libnss-mdns \
    libnss-myhostname \
    libvte-2.91-common \
    libvte-common \
    libvulkan1 \
    locales \
    lsof \
    man-db \
    manpages \
    mesa-vulkan-drivers \
    mtr \
    ncurses-base \
    openssh-client \
    passwd \
    pigz \
    pinentry-curses \
    procps \
    rsync \
    sudo \
    tcpdump \
    time \
    traceroute \
    tree \
    tzdata \
    unzip \
    util-linux \
    wget \
    xauth \
    xz-utils \
    zip

echo "Now installing sdbox packages"
DEBIAN_FRONTEND=noninteractive apt-get -y install \
    vim \
    emacs \
    tmux \
    powerline \
    btop \
    wireshark \
    ranger \
    polybar \
    make \
    meson \
    ninja-build \
    cmake \
    i3 \
    powerline-gitstatus \
    pipx \
    gcc \
    g++ \
    python3 \
    python3-pip \
    python3-cogapp \
    libcunit1-dev \
    libncurses-dev \
    pkg-config \
    libbz2-dev \
    liblzma-dev \
    libcunit1 \
    kitty \
    rofi \
    feh \
    libxext-dev \
    libxcb1-dev \
    libxcb-damage0-dev \
    libxcb-xfixes0-dev \
    libxcb-shape0-dev \
    libxcb-render-util0-dev \
    libxcb-render0-dev \
    libxcb-randr0-dev \
    libxcb-composite0-dev \
    libxcb-image0-dev \
    libxcb-present-dev \
    libxcb-xinerama0-dev \
    libxcb-glx0-dev \
    libpixman-1-dev \
    libdbus-1-dev \
    libconfig-dev \
    libgl1-mesa-dev \
    libpcre2-dev \
    libevdev-dev \
    uthash-dev \
    libev-dev \
    libx11-xcb-dev \
    xbindkeys \
    git-delta \
    flameshot \
    stow \
    ccls \
    ripgrep \
    fd-find

# TODO: CMAKE LANGUAGE SERVER AND OTHER LANGUAGE SERVERS AS WELL?

# TODO: Replace this with GNU stow
#echo Now installing dotfiles
#mkdir -p ~/.config
##cp debian_dotfiles/dotspacemacs ~/.spacemacs
#cp /opt/sdbox/debian_dotfiles/dotbashrc ~/.bashrc
#cp /opt/sdbox/debian_dotfiles/dotvimrc ~/.vimrc
#cp /opt/sdbox/debian_dotfiles/dotxbindkeysrc ~/.xbindkeysrc
#cp /opt/sdbox/debian_dotfiles/dottmux.conf ~/.tmux.conf
#cp -r /opt/sdbox/debian_dotfiles/dotconfig/* ~/.config

#echo Now installing githooks
#make -C /opt/sdbox/githooks

#echo Now installing fonts
#cp -r /opt/sdbox/fonts /usr/local/share

echo Now installing extra programs
pipx install --global pywal16

mkdir /tmp/sdbox && cd /tmp/sdbox
git clone https://github.com/plp13/qman.git
cd qman && meson setup build && cd build && meson compile && meson install

# TODO: doom emacs install
echo "Installing DOOM emacs"
git clone --depth 1 https://github.com/doomemacs/core /opt/sdbox/emacs
cd /opt/sdbox/emacs
git pull --tags
git checkout v2.2.4

/opt/sdbox/emacs/bin/doom --force --doomdir /opt/sdbox/debian_dotfiles/dotconfig/doom install

# FIXME: Error here complaining about nerd-icons no such file or dir
#emacs --batch -l /opt/sdbox/doom-post-install.el

# TODO: GNU stow this instead

#git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
#git clone https://github.com/dalanicolai/robot-framework-layer.git ~/.emacs.d/private/robot-framework
#
#echo Now installing spacemacs dependencies
#yes | emacs --batch -l ~/.emacs.d/init.el

#echo Now installing tmux plugins
#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#tmux new-session -d -s tmp
#~/.tmux/plugins/tpm/bindings/install_plugins
#tmux kill-session -t tmp
cd
rm -rf /tmp/sdbox
