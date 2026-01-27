FROM jetpackio/devbox:0.16.0 AS builder

WORKDIR /code/bi
USER root:root
RUN mkdir -p /code/bi && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/bi
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM aazw/devcontainers-devbox-python:6 AS runtime

USER root
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/bi/.devbox /code/bi/.devbox
USER vscode

ENV PATH="/code/bi/.devbox/nix/profile/default/bin:${PATH}"
