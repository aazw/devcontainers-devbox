FROM jetpackio/devbox:latest AS builder

WORKDIR /code/python-js
USER root:root
RUN mkdir -p /code/python-js && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/python-js
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM aazw/devcontainers-devbox-base:2 AS runtime

USER root
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/python-js/.devbox /code/python-js/.devbox
USER vscode

ENV PATH="/code/python-js/.devbox/nix/profile/default/bin:${PATH}"
