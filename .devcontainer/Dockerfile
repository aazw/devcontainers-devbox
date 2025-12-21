FROM debian:bookworm-slim

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    xz-utils \
    ca-certificates \
    git \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid $USER_GID $USERNAME
RUN useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /nix && chown $USERNAME:$USERNAME /nix

RUN mkdir -p /tmp/devbox-base && chown -R $USERNAME:$USERNAME /tmp/devbox-base

USER $USERNAME
ENV HOME=/home/$USERNAME

RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
RUN curl -fsSL https://get.jetify.com/devbox | bash -s -- -f

ENV PATH="/home/$USERNAME/.nix-profile/bin:/home/$USERNAME/.local/bin:${PATH}"

WORKDIR /tmp/devbox-base
COPY --chown=$USERNAME:$USERNAME images/base/devbox.json devbox.json
COPY --chown=$USERNAME:$USERNAME images/base/devbox.lock devbox.lock
RUN devbox install

ENV PATH="/tmp/devbox-base/.devbox/nix/profile/default/bin:${PATH}"

WORKDIR /
