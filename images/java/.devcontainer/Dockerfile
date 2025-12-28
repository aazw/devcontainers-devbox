FROM jetpackio/devbox:latest AS builder

WORKDIR /code/java
USER root:root
RUN mkdir -p /code/java && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/java
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM ghcr.io/aazw/devcontainers-devbox/base:9 AS runtime

USER root
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/java/.devbox /code/java/.devbox
USER vscode

ENV PATH="/code/java/.devbox/nix/profile/default/bin:${PATH}"
