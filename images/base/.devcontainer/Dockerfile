FROM jetpackio/devbox:latest AS builder

WORKDIR /code/base
USER root:root
RUN mkdir -p /code/base && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/base
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN devbox install


FROM debian:bookworm-slim AS runtime

# Nix/Devbox の実体とプロファイルをコピー（.devbox だけでは不足）
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/base/.devbox /code/base/.devbox

# CA は Nix 側のバンドルを優先して参照させる（apt-get 不要）
ENV PATH="/code/base/.devbox/nix/profile/default/bin:${PATH}" \
    SSL_CERT_FILE="/code/base/.devbox/nix/profile/default/etc/ssl/certs/ca-bundle.crt" \
    NIX_SSL_CERT_FILE="/code/base/.devbox/nix/profile/default/etc/ssl/certs/ca-bundle.crt" \
    GIT_SSL_CAINFO="/code/base/.devbox/nix/profile/default/etc/ssl/certs/ca-bundle.crt"

# runtime側ユーザ設定（apt-get 無しで /etc/passwd, /etc/group を追記）
ARG USERNAME=vscode
ARG USER_UID=10001
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd  --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME

USER $USERNAME
ENV HOME=/home/$USERNAME

# コンテナイメージデフォルトのbashを利用
WORKDIR /
CMD ["bash"]
