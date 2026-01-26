FROM jetpackio/devbox:0.16.0 AS builder

WORKDIR /code/rust
USER root:root
RUN mkdir -p /code/rust && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/rust
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM aazw/devcontainers-devbox-base:8 AS runtime

USER root
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/rust/.devbox /code/rust/.devbox
USER vscode

ENV PATH="/code/rust/.devbox/nix/profile/default/bin:${PATH}"
