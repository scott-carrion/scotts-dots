#!/usr/bin/env bash
set -euo pipefail

echo "[$0] Pre-installing base utils"
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

echo "[$0] Installing sdbox packages"
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
    ccls \
    ripgrep \
    fd-find \
    xsel

# TODO: CMAKE LANGUAGE SERVER AND OTHER LANGUAGE SERVERS LIKE BASH AS WELL?

echo "[$0] Installing extra programs"
pipx install --global pywal16==${PYWAL_VERSION}

# TODO: INSTALL HYPRLAND AND DMS

# TODO: Might want to make a .deb package of this?
mkdir -p /tmp/sdbox && cd /tmp/sdbox
git clone https://github.com/plp13/qman.git
cd qman
git checkout "${QMAN_VERSION}"
meson setup build && cd build && meson compile && meson install
cd
rm -rf /tmp/sdbox

echo "Installing DOOM emacs"
git clone https://github.com/doomemacs/core "${INSTALL_ROOT}/usr/emacs"
cd "${INSTALL_ROOT}/usr/emacs"
git checkout "${DOOM_EMACS_VERSION}"
cd
"${INSTALL_ROOT}/usr/emacs/bin/doom" --force --doomdir "${INSTALL_ROOT}/dots/config/doom" install

# Some direct dependencies of certain DOOM emacs layers don't install by default, for some reason
# Specifically, some fonts and a supporting shared object library for the integrated terminal (ghostel)
# The XDG_DATA_HOME inline setting makes the fonts install to systemwide location
mkdir -p "${INSTALL_ROOT}/usr/emacs/.local/straight"
XDG_DATA_HOME=/usr/share emacs --batch -l /mnt/container_scripts/doom-post-install.el

echo "[$0] Installing tmux plugins"
git clone https://github.com/tmux-plugins/tpm "${INSTALL_ROOT}/usr/tmux/plugins/tpm"
cd "${INSTALL_ROOT}/usr/tmux/plugins/tpm"
git checkout "${TPM_VERSION}"
cd

ln -sf "${INSTALL_ROOT}/dots/tmux.conf" /etc/tmux.conf
tmux -f /dev/null new-session -d -s tmp
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "${INSTALL_ROOT}/usr/tmux/plugins/"
"${INSTALL_ROOT}/usr/tmux/plugins/tpm/bindings/install_plugins"
tmux kill-server

echo "[$0] Installing githooks"
mkdir -p "${INSTALL_ROOT}/usr/git/githooks"
HOOKS_DST_DIR="${INSTALL_ROOT}/usr/git/githooks" make -C /mnt/container_scripts/githooks

echo "[$0] Setting rwx permissions on ${INSTALL_ROOT}"
chmod -R 777 "${INSTALL_ROOT}"
