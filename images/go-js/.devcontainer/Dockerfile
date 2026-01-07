FROM jetpackio/devbox:0.16.0 AS builder

WORKDIR /code/go-js
USER root:root
RUN mkdir -p /code/go-js && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/go-js
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM aazw/devcontainers-devbox-base:2 AS runtime

USER root
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/go-js/.devbox /code/go-js/.devbox
USER vscode

ENV PATH="/code/go-js/.devbox/nix/profile/default/bin:${PATH}"
