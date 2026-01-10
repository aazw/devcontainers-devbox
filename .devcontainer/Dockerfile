# =============================================================================
# Devcontainer Dockerfile
# =============================================================================
# このDockerfileは、Devbox + Nixを使用した開発環境を構築します。
# Debian Bookworm (slim) をベースに、Nix パッケージマネージャーと
# Devbox をインストールし、宣言的なパッケージ管理を実現します。
# =============================================================================

# -----------------------------------------------------------------------------
# ベースイメージ
# -----------------------------------------------------------------------------
# Debian Bookworm (安定版) の軽量イメージを使用
# slim版はドキュメントや不要なパッケージを除外し、イメージサイズを削減
FROM debian:bookworm-slim

# -----------------------------------------------------------------------------
# ビルド引数の定義
# -----------------------------------------------------------------------------
# USERNAME: 作成するユーザー名 (デフォルト: vscode)
# USER_UID: ユーザーID (デフォルト: 1000)
# USER_GID: グループID (デフォルト: USER_UIDと同じ)
# これらはホストのUID/GIDと合わせることでファイル権限の問題を回避できる
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# -----------------------------------------------------------------------------
# 必要なシステムパッケージのインストール
# -----------------------------------------------------------------------------
# curl: Nix/Devboxのインストールスクリプト取得に使用
# sudo: 開発時の管理者権限操作に使用
# xz-utils: Nixパッケージの展開に必要
# ca-certificates: HTTPS通信の証明書検証に必要
# git: バージョン管理 (Devboxの一部機能でも使用)
# --no-install-recommends: 推奨パッケージを除外しイメージサイズを削減
# 最後にapt cacheを削除してイメージサイズを削減
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    xz-utils \
    ca-certificates \
    git \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# 非rootユーザーの作成
# -----------------------------------------------------------------------------
# セキュリティのため非rootユーザーで開発環境を実行
# グループを作成し、ユーザーを作成してホームディレクトリを自動生成
# sudoを パスワードなしで実行可能にして開発時の利便性を確保
RUN groupadd --gid $USER_GID $USERNAME
RUN useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

# -----------------------------------------------------------------------------
# Nix用ディレクトリの準備
# -----------------------------------------------------------------------------
# /nixディレクトリはNixがパッケージを格納する場所
# 非rootユーザーでNixを使用するため、事前に所有権を設定
RUN mkdir -p /nix && chown $USERNAME:$USERNAME /nix

# -----------------------------------------------------------------------------
# Devbox用一時ディレクトリの準備
# -----------------------------------------------------------------------------
# devbox-base: ベースとなる共通パッケージ (images/base/devbox.json)
# devbox-devcontainer: devcontainer固有の追加パッケージ
# これらを分離することで、プロジェクト固有の設定を柔軟に管理可能
RUN mkdir -p /tmp/devbox-base && chown -R $USERNAME:$USERNAME /tmp/devbox-base
RUN mkdir -p /tmp/devbox-devcontainer && chown -R $USERNAME:$USERNAME /tmp/devbox-devcontainer

# -----------------------------------------------------------------------------
# 実行ユーザーの切り替え
# -----------------------------------------------------------------------------
# 以降のコマンドは非rootユーザーとして実行
# HOME環境変数を明示的に設定 (一部ツールで必要)
USER $USERNAME
ENV HOME=/home/$USERNAME

# -----------------------------------------------------------------------------
# Nix パッケージマネージャーのインストール
# -----------------------------------------------------------------------------
# --no-daemon: シングルユーザーモードでインストール
# (コンテナ環境ではデーモンモードは不要なため)
# Nixは再現可能なパッケージ管理を提供し、Devboxの基盤となる
RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

# -----------------------------------------------------------------------------
# Devbox のインストール
# -----------------------------------------------------------------------------
# DevboxはNixをラップし、よりシンプルな開発環境管理を提供
# -f: 既存のインストールがあっても強制的に再インストール
RUN curl -fsSL https://get.jetify.com/devbox | bash -s -- -f

# -----------------------------------------------------------------------------
# PATHの設定
# -----------------------------------------------------------------------------
# Nixとdevboxのバイナリにパスを通す
# .nix-profile/bin: Nixでインストールしたパッケージ
# .local/bin: devboxコマンド自体
ENV PATH="/home/$USERNAME/.nix-profile/bin:/home/$USERNAME/.local/bin:${PATH}"

# -----------------------------------------------------------------------------
# ベースDevbox環境のセットアップ
# -----------------------------------------------------------------------------
# images/base/devbox.json に定義された共通パッケージをインストール
# このレイヤーはキャッシュされ、ベース設定が変わらない限り再利用される
WORKDIR /tmp/devbox-base
COPY --chown=$USERNAME:$USERNAME images/base/devbox.json devbox.json
COPY --chown=$USERNAME:$USERNAME images/base/devbox.lock devbox.lock
RUN devbox install

# devbox installで追加されたパッケージのパスを追加
ENV PATH="/tmp/devbox-base/.devbox/nix/profile/default/bin:${PATH}"

ENV XDG_DATA_DIRS="/tmp/devbox-base/.devbox/nix/profile/default/share:${XDG_DATA_DIRS}"

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV LOCALE_ARCHIVE="/tmp/devbox-base/.devbox/nix/profile/default/lib/locale/locale-archive"

# -----------------------------------------------------------------------------
# Devcontainer固有の追加Devbox環境のセットアップ
# -----------------------------------------------------------------------------
# .devcontainer/devbox.json に定義されたdevcontainer専用パッケージをインストール
# ベース環境とは別にレイヤー化することで、devcontainer設定のみの変更時に
# ベースレイヤーのキャッシュを活用できる
WORKDIR /tmp/devbox-devcontainer
COPY --chown=$USERNAME:$USERNAME .devcontainer/devbox.json devbox.json
COPY --chown=$USERNAME:$USERNAME .devcontainer/devbox.lock devbox.lock
RUN devbox install

# devcontainer固有パッケージのパスを追加
ENV PATH="/tmp/devbox-devcontainer/.devbox/nix/profile/default/bin:${PATH}"

# -----------------------------------------------------------------------------
# 作業ディレクトリのリセット
# -----------------------------------------------------------------------------
# コンテナ起動時のデフォルト作業ディレクトリをルートに設定
# (実際にはdevcontainer.jsonでworkspaceFolderが上書きされる)
WORKDIR /
