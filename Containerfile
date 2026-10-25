ARG BASE_IMAGE="quay.io/toolbx-images/debian-toolbox:13"
FROM ${BASE_IMAGE}

# Install location for dotfiles, IDE dependencies, and tmux plugins
ARG INSTALL_ROOT="/opt/sdbox"
ENV INSTALL_ROOT="${INSTALL_ROOT}"

# Pinned versions for programs
ARG TPM_VERSION="e261deb1b47614eed3400089ce7197dc68acc4eb"
ENV TPM_VERSION="${TPM_VERSION}"
ARG QMAN_VERSION="e7a4119677d3c2cef12b525ec179f5b1b40303b4"
ENV QMAN_VERSION="${QMAN_VERSION}"
ARG DOOM_EMACS_VERSION="v2.2.4"
ENV DOOM_EMACS_VERSION="${DOOM_EMACS_VERSION}"
ARG PYWAL_VERSION="3.8.15"
ENV PYWAL_VERSION="${PYWAL_VERSION}"

# tmux default session and socket names
# Make these different from "main" and "default" to avoid confusion with host tmux sessions
ENV TMUX_DEFAULT_SESSION_NAME="sdbmain"
ENV TMUX_SOCKET_NAME="sdbox"

# Set up install root and copy dotfiles to container
RUN mkdir -p "${INSTALL_ROOT}/usr"
COPY dots "${INSTALL_ROOT}/dots"

# Copy fonts to systemwide install location
COPY fonts/ /usr/share/fonts

# Run install packages script but don't install it as we won't need it at runtime
RUN --mount=type=bind,source=./container_scripts,target=/mnt/container_scripts /mnt/container_scripts/install_packages.sh

# Generate en_US.UTF-8 locale (container has C en_US locale only by default)
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
