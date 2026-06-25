---
title: ADR-0009 mise のインストールを chezmoi apply で行う
status: Accepted
date: 2026-06-25
---

# ADR-0009 mise のインストールを chezmoi apply で行う

## 🤔 背景

ADR-0007 で mise をツール管理に採用し、当初は ADR-0006 の zinit を利用して mise バイナリをインストールしていた（zinit の `from'gh-r'` 機能で GitHub Releases からダウンロード）。しかし、この方式ではテストに以下の問題が生じた:

1. mise の存在確認に `zsh -i`（インタラクティブセッション）の起動が必須となり、テストが zsh + zinit の初期化に依存する
2. mise がインストールされるパスが zinit 内部のディレクトリ（`~/.local/share/zinit/plugins/mise`）となり、後続テストで zinit 固有のパスをハードコードする必要がある
3. テストフェーズが「chezmoi apply → zsh -i（zinit が mise をインストール）→ mise install」の 3 段階に分かれ、Phase 2 が zinit の動作確認と mise のインストール確認を兼ねるため責務が曖昧になる

mise 自体はシングルバイナリであり、zsh プラグインとしての性質を持たない。zinit を経由してインストールする技術的必然性はなく、chezmoi apply 時に直接インストールする方が関心の分離として適切である。

## 💡 決定事項

mise のインストールを chezmoi の `run_` スクリプトで行い、`mise install` による各種ツールのセットアップも chezmoi apply の過程で完結させる。

### 決定に至った差別化要素

chezmoi apply だけで mise とツール群のインストールが完結するため、テスト時に zsh インタラクティブセッションを経由する必要がなくなる。これにより、テストフェーズから zinit 依存を除去でき、「chezmoi apply → ツール検証」の 2 段階に簡素化できる。

zinit の役割は本来「zsh プラグイン管理」であり（ADR-0006）、汎用バイナリのインストールは責務外である。mise のインストールを chezmoi 側に移すことで、各ツールの責務が明確になる。

## 🔍 検討した選択肢

|  | テスト容易性 | 責務の明確さ | 実装の単純さ | シェル起動速度 |
| --- | --- | --- | --- | --- |
| chezmoi apply でインストール | ✅ zsh -i 不要 | ✅ zinit はプラグインのみ | ✅ run_ スクリプト1本 | ✅ zinit のロード対象が減る |
| zinit 経由でインストール（現行） | ❌ zsh -i 必須 | ⚠️ zinit がバイナリ管理を兼務 | ⚠️ テストで zinit パスをハードコード | ⚠️ 起動時にダウンロード確認が走る |

### 1️⃣ zinit 経由でインストール（現行方式）

zinit の `from'gh-r'` でGitHub Releases から mise バイナリをダウンロードし、zinit プラグインディレクトリに配置する。`atload` で `mise activate zsh` を実行する。

- ❌ テスト容易性: mise の存在確認に `zsh -i` が必要。CI テストが zinit の初期化完了に依存する
- ⚠️ 責務の明確さ: zinit が zsh プラグイン管理と汎用バイナリのインストールを兼務する
- ⚠️ 実装の単純さ: テストで `$HOME/.local/share/zinit/plugins/mise` を PATH に追加する必要がある
- ⚠️ シェル起動速度: 初回起動時にダウンロード・展開が走り、バージョン確認のネットワークアクセスも発生しうる

## 🔗 関連ADR

- Related: [ADR-0006 zsh プラグイン管理に zinit を使用する](ADR-0006-adopt-zinit-for-plugin-management.md)
- Related: [ADR-0007 ツールのインストールに原則 mise を使用する](ADR-0007-adopt-mise-for-tool-installation.md)

## 📄 参考資料

- [mise インストール方法](https://mise.jdx.dev/getting-started.html#installation)
- [chezmoi run_ スクリプト](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
