FROM jetpackio/devbox:0.16.0 AS builder

WORKDIR /code/js
USER root:root
RUN mkdir -p /code/js && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/js
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM aazw/devcontainers-devbox-base:8 AS runtime

USER root
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/js/.devbox /code/js/.devbox
USER vscode

ENV PATH="/code/js/.devbox/nix/profile/default/bin:${PATH}"
