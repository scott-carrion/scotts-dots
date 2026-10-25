FROM quay.io/toolbx-images/debian-toolbox:13

RUN mkdir -p /opt/sdbox
COPY scripts/install_packages.sh /opt/sdbox/install_packages.sh
COPY scripts/doom-post-install.el /opt/sdbox/doom-post-install.el
COPY debian_dotfiles /opt/sdbox/debian_dotfiles
COPY githooks /opt/sdbox/githooks
COPY fonts/ /usr/share/fonts
RUN /opt/sdbox/install_packages.sh
