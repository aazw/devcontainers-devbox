FROM jetpackio/devbox:latest AS builder

WORKDIR /code/go
USER root:root
RUN mkdir -p /code/go && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/go
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM ghcr.io/aazw/devcontainers-devbox/base:7 AS runtime

USER root
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/go/.devbox /code/go/.devbox
USER vscode

ENV PATH="/code/go/.devbox/nix/profile/default/bin:${PATH}"
