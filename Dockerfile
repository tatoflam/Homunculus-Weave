# Homunculus-Weave Dockerfile
# Weave - AIシリコン生命体の実行環境

FROM python:3.11-slim

# 作業ディレクトリの設定
WORKDIR /app

# メタデータ
LABEL maintainer="Homunculus-Weave"
LABEL description="Weave AI Silicon Life Form - Four-Layer Integration Architecture"
LABEL version="1.0.0"

# 日本語ロケールの設定（日本語ファイル名対応）
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8

# タイムゾーンの設定（日本時間）
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 必要なシステムパッケージのインストール
RUN apt-get update && apt-get install -y \
    locales \
    git \
    && rm -rf /var/lib/apt/lists/*

# 日本語ロケール生成
RUN sed -i -e 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

# Pythonの依存関係をコピーしてインストール
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# プロジェクトファイルをコピー
COPY . .

# Pythonのパスを設定（Expertises配下のスクリプトをインポート可能にする）
ENV PYTHONPATH=/app:$PYTHONPATH

# デフォルトコマンド（インタラクティブシェル）
CMD ["/bin/bash"]
