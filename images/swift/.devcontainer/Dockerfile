# swift

# renovate: suite=bookworm depName=libc6-dev
ARG LIBC6_DEV_VERSION=2.36-9+deb12u13

# renovate: suite=bookworm depName=linux-libc-dev
ARG LINUX_LIBC_DEV_VERSION=6.1.159-1

FROM jetpackio/devbox:0.16.0 AS builder

WORKDIR /code/swift
USER root:root
RUN mkdir -p /code/swift && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/swift
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install

FROM aazw/devcontainers-devbox-base:9 AS runtime

USER root

# swift --versionをした際などに、
# 『<unknown>:0: warning: glibc not found for 'aarch64-unknown-linux-gnu'; C stdlib may be unavailable』みたいなエラーが出ないようにする
ARG LIBC6_DEV_VERSION
ARG LINUX_LIBC_DEV_VERSION
RUN apt-get update && apt-get install -y --no-install-recommends \
    libc6-dev=${LIBC6_DEV_VERSION} \
    linux-libc-dev=${LINUX_LIBC_DEV_VERSION} \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/swift/.devbox /code/swift/.devbox
USER vscode

ENV PATH="/code/swift/.devbox/nix/profile/default/bin:${PATH}"

# libdispatch.so を実行時に見つけられるようにする
# swift-corelibs-libdispatch の lib がプロファイルにリンクされないため、
# nix ストア内のパスを LD_LIBRARY_PATH に追加する
RUN LIBDISPATCH_PATH=$(find /nix/store -maxdepth 1 -name '*-swift-corelibs-libdispatch-*' -type d ! -name '*-dev' ! -name '*-man' 2>/dev/null | head -1)/lib \
    && echo "export LD_LIBRARY_PATH=\"$LIBDISPATCH_PATH:\$LD_LIBRARY_PATH\"" >>~/.bashrc \
    && echo "export LD_LIBRARY_PATH=\"$LIBDISPATCH_PATH:\$LD_LIBRARY_PATH\"" >>~/.zshrc
