FROM jetpackio/devbox:0.16.0 AS builder

WORKDIR /code/python
USER root:root
RUN mkdir -p /code/python && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/python
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM aazw/devcontainers-devbox-base:8 AS runtime

USER root
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/python/.devbox /code/python/.devbox
USER vscode

ENV PATH="/code/python/.devbox/nix/profile/default/bin:${PATH}"
