FROM jetpackio/devbox:0.16.0 AS builder

WORKDIR /code/swift
USER root:root
RUN mkdir -p /code/swift && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/swift
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM aazw/devcontainers-devbox-base:2 AS runtime

USER root
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
