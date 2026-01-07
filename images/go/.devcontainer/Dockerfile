FROM jetpackio/devbox:0.16.0 AS builder

WORKDIR /code/go
USER root:root
RUN mkdir -p /code/go && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/go
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM aazw/devcontainers-devbox-base:2 AS runtime

USER root
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/go/.devbox /code/go/.devbox
USER vscode

ENV PATH="/code/go/.devbox/nix/profile/default/bin:${PATH}"
