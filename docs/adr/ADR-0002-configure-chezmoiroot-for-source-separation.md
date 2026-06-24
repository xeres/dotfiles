---
title: ADR-0002 .chezmoiroot で home/ ディレクトリをソースルートに設定する
status: Accepted
date: 2026-06-23
---

# ADR-0002 .chezmoiroot で home/ ディレクトリをソースルートに設定する

## 🤔 背景

chezmoi のソースディレクトリ（`~/.local/share/chezmoi`）はデフォルトではリポジトリルートと一致する。しかし、dotfiles リポジトリには chezmoi が管理するファイル以外にも `Dockerfile`、`Makefile`、テストコード、ドキュメントなどプロジェクト運用に必要なファイルを配置したい。これらをソースディレクトリに含めると chezmoi が管理対象として認識してしまう。

## 💡 決定事項

`.chezmoiroot` ファイルに `home` と記述し、`home/` ディレクトリ配下を chezmoi のソースルートとして扱う。リポジトリルートにはプロジェクト運用ファイル（Dockerfile、Makefile、docs/ 等）を自由に配置できるようにする。

### 決定に至った差別化要素

`.chezmoiroot` を使うことで、chezmoi 管理対象のファイルとプロジェクト運用ファイルを明確に分離できる。`.chezmoiignore` で個別に除外する方法と比べて、除外ルールの保守が不要で、ディレクトリ構造から意図が一目で伝わる。

## 🔍 検討した選択肢

|  | 関心の分離 | 保守性 | 設定の単純さ |
| --- | --- | --- | --- |
| .chezmoiroot | ✅ 完全に分離 | ✅ 追加ファイルに対応不要 | ✅ 1行記述のみ |
| .chezmoiignore | ⚠️ 除外ルールで対応 | ❌ ファイル追加ごとに更新 | ⚠️ パターン管理が必要 |
| リポジトリルートに直接配置 | ❌ 混在する | ✅ 設定不要 | ✅ 設定不要 |

### 1️⃣ .chezmoiignore で除外

chezmoi の ignore ファイルに `Dockerfile`、`Makefile`、`docs/` 等を列挙して除外する方法。

- ⚠️ 関心の分離: ファイルシステム上は混在したまま、論理的に除外する
- ❌ 保守性: プロジェクトファイルを追加するたびに ignore ルールの更新が必要
- ⚠️ 設定の単純さ: glob パターンの管理が必要

### 2️⃣ リポジトリルートに直接配置

chezmoi のソース（`dot_` プレフィクス付きファイル）とプロジェクトファイルをルートに混在させる方法。

- ❌ 関心の分離: dotfiles とプロジェクトファイルが同階層に混在し、見通しが悪い
- ✅ 保守性: 追加設定不要
- ✅ 設定の単純さ: 何も設定しない

## 📄 参考資料

- [chezmoi .chezmoiroot ドキュメント](https://www.chezmoi.io/reference/special-files-and-directories/chezmoiroot/)
