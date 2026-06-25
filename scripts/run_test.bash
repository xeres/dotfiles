#!/usr/bin/env bash
set -euo pipefail

# テストはコンテナ起動後の環境構築フェーズに対応して段階的に実行する。
#
#   Docker build (テスト対象外)
#     OS 基盤パッケージのインストールとユーザー作成、chezmoi apply による dotfiles 配置。
#     chezmoi apply により run_ スクリプトが実行され、mise および各種ツールもインストールされる。
#
#   Phase 1: chezmoi apply 後の検証 (bash)
#     dotfiles が正しく配置されたか、設定ファイルの内容が期待通りかを検証する。
#     bash から直接実行でき、追加のランタイムセットアップは不要。
#
#   Phase 2: mise ツールの検証 (bash)
#     mise install により Node.js や uv 等のツールがインストールされ、
#     コマンドとして利用可能であること、設定が正しく適用されていることを検証する。

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEST_DIR="$SCRIPT_DIR/../test"

echo "=== Phase 1: chezmoi apply ==="
bats "$TEST_DIR/phase1"

echo "=== Phase 2: mise tools ==="
bats "$TEST_DIR/phase2"
