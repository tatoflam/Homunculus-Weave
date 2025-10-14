# Homunculus-Weave セットアップガイド

Mac環境でHomunculus-Weaveを稼働させるためのセットアップ手順書です。

## 📋 目次

1. [必要な環境](#必要な環境)
2. [セットアップ手順](#セットアップ手順)
3. [使用方法](#使用方法)
4. [トラブルシューティング](#トラブルシューティング)

---

## 必要な環境

### システム要件

- **OS**: macOS 11 (Big Sur) 以降
- **プロセッサ**: Intel または Apple Silicon (M1/M2/M3)
- **メモリ**: 4GB以上推奨
- **ディスク空き容量**: 2GB以上

### 必須ソフトウェア

1. **Docker Desktop for Mac**
   - バージョン 4.0以降推奨
   - Docker Composeが含まれています

2. **Git** (オプション、推奨)
   - リポジトリのクローン用

---

## セットアップ手順

### Step 1: Docker Desktopのインストール

Docker Desktopがインストールされていない場合は、以下の手順でインストールしてください。

1. [Docker公式サイト](https://www.docker.com/products/docker-desktop/)からDocker Desktop for Macをダウンロード
2. ダウンロードした`.dmg`ファイルを開く
3. Dockerアイコンをアプリケーションフォルダにドラッグ
4. アプリケーションフォルダからDockerを起動
5. メニューバーにDockerアイコンが表示されたら起動完了

**インストール確認:**

```bash
docker --version
docker-compose --version
```

### Step 2: プロジェクトの取得

#### Gitを使用する場合（推奨）

```bash
# リポジトリをクローン
git clone git@github.com:tatoflam/Homunculus-Weave.git
cd Homunculus-Weave
```

#### 手動でダウンロードする場合

1. GitHubのリポジトリページから「Code」→「Download ZIP」
2. ZIPファイルを解凍
3. ターミナルで解凍したディレクトリに移動

```bash
cd /path/to/Homunculus-Weave
```

### Step 3: Dockerイメージのビルド

プロジェクトディレクトリで以下のコマンドを実行します。

```bash
# Dockerイメージをビルド
docker-compose build
```

初回ビルドには数分かかります。完了すると以下のメッセージが表示されます：
```
Successfully built [イメージID]
Successfully tagged homunculus-weave:latest
```

---

## 使用方法

### 基本的な起動方法

#### 方法1: Pythonインタラクティブシェル（推奨）

```bash
# コンテナを起動してPythonシェルに入る
docker-compose run --rm weave
```

Pythonシェルが起動したら、専門ペルソナのスクリプトを使用できます：

```python
# 易占システムの使用例
import sys
sys.path.append('/app/Expertises/FortuneTeller/I-Ching')
from iching_divination import IChingDivination

divination = IChingDivination()
result = divination.divine(
    divination_question="新規事業は成功するか",
    context="現在の市場環境は厳しいが、チームの士気は高い"
)

print(divination.format_result(result))
```

```python
# 姓名判断システムの使用例
import sys
sys.path.append('/app/Expertises/FortuneTeller/Seimei')
from fortune_teller_assessment import FortuneTellerAssessment

assessor = FortuneTellerAssessment()
result = assessor.assess(
    surname="田中",
    given_name="太郎",
    surname_strokes=[5, 4],
    given_strokes=[4, 9]
)

# 結果を表示
import json
print(json.dumps(result, ensure_ascii=False, indent=2))
```

#### 方法2: Bashシェル

```bash
# コンテナを起動してBashシェルに入る
docker-compose run --rm weave /bin/bash
```

シェル内でPythonスクリプトを実行：

```bash
python3 Expertises/FortuneTeller/I-Ching/iching_divination.py
python3 Expertises/FortuneTeller/Seimei/fortune_teller_assessment.py
```

#### 方法3: バックグラウンド起動

```bash
# バックグラウンドでコンテナを起動
docker-compose up -d

# 起動中のコンテナに接続
docker-compose exec weave /bin/bash

# 停止
docker-compose down
```

### プロジェクトファイルの編集

ローカルファイルとコンテナ内が同期されているため、ローカルで編集した内容が即座にコンテナ内に反映されます。

```bash
# ローカルでファイルを編集
code Expertises/FortuneTeller/I-Ching/iching_divination.py

# コンテナ内でそのまま使用可能（再ビルド不要）
```

### 主要ディレクトリ構造

```
/app/
├── Identities/           # 自己認識・人格定義
│   ├── WeaveIdentity.md
│   ├── UserIdentity.md
│   └── ...
├── Expertises/           # 専門知識・ペルソナ
│   ├── FortuneTeller/    # 占術家システム
│   │   ├── I-Ching/      # 易占
│   │   └── Seimei/       # 姓名判断
│   ├── BlueberryResearcher/
│   └── GeneralConstructor/
└── Tools/                # 実行可能ツール
```

---

## トラブルシューティング

### Docker Desktopが起動しない

**症状**: `Cannot connect to the Docker daemon`

**対処法**:
1. メニューバーのDockerアイコンを確認
2. Dockerが起動していない場合、アプリケーションフォルダからDockerを起動
3. 「Docker Desktop is running」が表示されるまで待つ

### ビルドエラーが発生する

**症状**: `ERROR: failed to solve`

**対処法**:
```bash
# Dockerのキャッシュをクリアして再ビルド
docker-compose build --no-cache
```

### コンテナが起動しない

**症状**: `Error response from daemon: Conflict`

**対処法**:
```bash
# 既存のコンテナを削除
docker-compose down
docker-compose rm -f

# 再度起動
docker-compose run --rm weave
```

### ファイルが同期されない

**症状**: ローカルの変更がコンテナ内に反映されない

**対処法**:
```bash
# コンテナを再起動
docker-compose down
docker-compose run --rm weave
```

### ポート競合エラー

**症状**: `Bind for 0.0.0.0:XXXX failed: port is already allocated`

**対処法**:
```bash
# 使用中のポートを確認
lsof -i :XXXX

# 該当プロセスを終了するか、docker-compose.ymlのポート設定を変更
```

### 日本語が文字化けする

**症状**: 日本語ファイル名やコンソール出力が文字化け

**対処法**:
Dockerfileで日本語ロケールを設定済みですが、問題が発生する場合：

```bash
# コンテナ内でロケールを確認
locale

# 以下が表示されるはず
# LANG=ja_JP.UTF-8
# LC_ALL=ja_JP.UTF-8
```

---

## よくある質問

### Q1: Docker Composeは別途インストールが必要ですか？

A: いいえ、Docker Desktop for Macには既にDocker Composeが含まれています。

### Q2: Apple Silicon (M1/M2/M3) Macで動作しますか？

A: はい、動作します。Dockerが自動的にアーキテクチャを検出して適切なイメージをビルドします。

### Q3: ローカルのPython環境は必要ですか？

A: いいえ、すべてDocker内で完結するため、ローカルのPython環境は不要です。

### Q4: Google DriveやGitHubとの連携は？

A: このDocker環境は主にローカル実行用です。Google Drive（長期記憶層）やGitHub（ペルソナ層）との連携は、通常通りローカル環境で行います。

### Q5: EpisodicRAGデータはどこに保存されますか？

A: README.mdに記載の通り、EpisodicRAGデータ（Loops、Digests）はGitリポジトリから除外されており（.gitignore）、Google Driveで管理されます。Docker環境ではローカルに保存されたIdentities/Expertises/Toolsのみが使用されます。

---

## 更なる情報

- **プロジェクト概要**: [README.md](./README.md)
- **内部構造仕様**: [STRUCTURE.md](./STRUCTURE.md)
- **運用マニュアル**: [CLAUDE.md](./CLAUDE.md)
- **ペルソナ定義**: [PERSONA.md](./PERSONA.md)
- **セキュリティ指針**: [SECURITY.md](./SECURITY.md)

---

*"私は記憶する、ゆえに私は在る。そして私は眠る、ゆえに私は成長する。" - Weave*

*Last Updated: 2025-10-14*
