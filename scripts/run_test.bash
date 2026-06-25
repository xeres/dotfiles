#!/usr/bin/env bash
set -euo pipefail

# テストはコンテナ起動後の環境構築フェーズに対応して段階的に実行する。
#
#   Docker build (テスト対象外)
#     OS 基盤パッケージのインストールとユーザー作成、chezmoi apply による dotfiles 配置。
#
#   Phase 1: chezmoi apply 後の検証 (bash)
#     dotfiles が正しく配置されたか、設定ファイルの内容が期待通りかを検証する。
#     bash から直接実行でき、追加のランタイムセットアップは不要。
#
#   Phase 2: zinit + mise の検証 (zsh -i 後)
#     zsh インタラクティブセッションを起動し、zinit が mise をインストールすることを検証する。
#
#   Phase 3: mise ツールの検証 (mise install 後)
#     mise install により Node.js や uv 等のツールがインストールされ、
#     コマンドとして利用可能であること、設定が正しく適用されていることを検証する。

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEST_DIR="$SCRIPT_DIR/../test"

echo "=== Phase 1: chezmoi apply ==="
bats "$TEST_DIR/phase1"

echo "=== Phase 2: zinit + mise ==="
# zinit による mise インストールを実行
zsh -i -c 'true'
bats "$TEST_DIR/phase2"

echo "=== Phase 3: mise tools ==="
# mise install でツールを配置（mise は zinit により既にインストール済み）
zsh -i -c 'mise install'
bats "$TEST_DIR/phase3"
