FROM jetpackio/devbox:0.16.0 AS builder

WORKDIR /code/base
USER root:root
RUN mkdir -p /code/base && chown ${DEVBOX_USER}:${DEVBOX_USER} /code/base
USER ${DEVBOX_USER}:${DEVBOX_USER}

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
RUN DEVBOX_DEBUG=1 devbox install


FROM debian:bookworm-slim AS runtime

# runtime側ユーザ設定（apt-get 無しで /etc/passwd, /etc/group を追記）
ARG USERNAME=vscode
ARG USER_UID=10001
ARG USER_GID=$USER_UID

# Nix/Devbox の実体とプロファイルをコピー（.devbox だけでは不足）
COPY --from=builder /nix/store /nix/store
COPY --from=builder /code/base/.devbox /code/base/.devbox

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME

# =============================
# devbox shellenv 相当のENV設定
# =============================

ENV PATH="/code/base/.devbox/nix/profile/default/bin:${PATH}"

# CA は Nix 側のバンドルを優先して参照させる（apt-get 不要）
ENV SSL_CERT_FILE="/code/base/.devbox/nix/profile/default/etc/ssl/certs/ca-bundle.crt"
ENV NIX_SSL_CERT_FILE="/code/base/.devbox/nix/profile/default/etc/ssl/certs/ca-bundle.crt"
ENV GIT_SSL_CAINFO="/code/base/.devbox/nix/profile/default/etc/ssl/certs/ca-bundle.crt"

# mermaid-cliでsvg等出力時に文字が描画されない問題対応
ENV XDG_DATA_DIRS="/code/base/.devbox/nix/profile/default/share:${XDG_DATA_DIRS}"

# 日本語表示だけで日本語ロケール固有の動作（日付形式等）が不要
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV LOCALE_ARCHIVE="/code/base/.devbox/nix/profile/default/lib/locale/locale-archive"

USER $USERNAME
ENV HOME=/home/$USERNAME

# puppeteer-config.json with alias
COPY ./puppeteer-config.json /home/vscode/puppeteer-config.json
RUN echo "alias mmdc='mmdc --puppeteerConfigFile /home/vscode/puppeteer-config.json'" >>/home/vscode/.bashrc

# コンテナイメージデフォルトのbashを利用
WORKDIR /
CMD ["bash"]
