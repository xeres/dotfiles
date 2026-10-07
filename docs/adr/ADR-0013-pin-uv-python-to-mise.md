---
title: ADR-0013 UV_PYTHON を mise 管理の python に固定する
status: Accepted
date: 2026-10-07
---

# ADR-0013 UV_PYTHON を mise 管理の python に固定する

## 🤔 背景

ツールのインストールは原則 mise に一元化している（ADR-0007）。一方で uv は、プロジェクトや操作に応じて python を自前でダウンロード・管理する機能を持ち、放置すると「mise が入れた python」と「uv が入れた python」が二重に存在しうる。

また本リポジトリは供給チェーン対策として cooldown を敷いており（ADR-0008）、mise は `minimum_release_age = "7d"`、uv は `exclude-newer = "7 days"` を設定している。uv が独自に python を取得すると、python 実体の管理主体が分かれ、どちらのポリシーが効くのかが曖昧になる。

## 💡 決定事項

mise の config.toml で `[env] UV_PYTHON = { value = "{{ tools.python.path }}", tools = true }` を設定し、uv が参照する python を mise 管理の python 実体に固定する。python 自体も mise の管理対象ツール（`python = "latest"`）として明示する。

### 決定に至った差別化要素

`UV_PYTHON` を mise の python パスに向けることで、uv は新たに python をダウンロードせず mise が入れた python を使う。これにより python 実体が mise に一元化され（ADR-0007 の方針と一致）、二重管理がなくなる。結果として、python の取得は mise の cooldown ポリシー下に置かれ、uv が cooldown を迂回して新しい python を取得する余地もなくなる（ADR-0008 と整合）。

mise 側から取り込む `mise sync python --uv` も検討したが採用しなかった。これは uv がインストールした python を mise に symlink する 2-way sync であり、chezmoi apply とは別に手で実行する命令的な同期ステップを要する。本リポジトリは設定を宣言的に管理する方針（ADR-0001）であり、config.toml に書けば apply だけで効く `UV_PYTHON` と異なり、`mise sync` の都度実行は宣言的管理の原則に反する。

デメリットとして、mise の `{{ tools.python.path }}` テンプレート展開に依存するため、mise のパス解決仕様に結合する。この固定が実際に効いているかは、uv が解決する python 実体と mise 管理の python 実体が一致することをテスト（`test/common/tools.bats`）で検証して担保する。

## 🔍 検討した選択肢

|  | 管理の一元性 | cooldown ポリシー整合 | 宣言的管理との整合 |
| --- | --- | --- | --- |
| UV_PYTHON を mise python に固定 | ✅ mise に一元化 | ✅ mise の cooldown 下 | ✅ apply だけで完結 |
| mise sync python --uv で取り込む | ❌ uv が取得した python を symlink（二重管理は残る） | ❌ uv 側の取得が前提 | ❌ sync の都度実行が必要（命令的） |
| uv に python を任せる | ❌ 二重管理 | ❌ uv が独自取得 | ⚠️ 設定不要だが実体は非決定的 |

### 1️⃣ mise sync python --uv で取り込む

uv がインストールした python を `mise sync python --uv`（2-way sync）で mise に symlink し、相互に見えるようにする。

- ❌ 管理の一元性: 取得主体は uv のままで、symlink が増えるだけ。実体の二重管理は解消しない
- ❌ cooldown ポリシー整合: python の取得が uv 側で起きる前提のため、mise の cooldown に乗らない
- ❌ 宣言的管理との整合: chezmoi apply とは別に `mise sync` を手で実行する命令的ステップが必要

### 2️⃣ uv に python 管理を任せる

`UV_PYTHON` を設定せず、uv が必要に応じて python を取得する。

- ❌ 管理の一元性: mise の python と uv の python が別々に存在しうる
- ❌ cooldown ポリシー整合: uv が独自に新しい python を取得でき、mise の cooldown を迂回しうる
- ⚠️ 宣言的管理との整合: 追加設定は不要だが、どの python が使われるかが操作に依存して非決定的になる

## 🔗 関連ADR

- Related: [ADR-0001 chezmoi を dotfiles 管理ツールとして採用する](ADR-0001-adopt-chezmoi-for-dotfiles-management.md)
- Related: [ADR-0007 ツールのインストールに原則 mise を使用する](ADR-0007-adopt-mise-for-tool-installation.md)
- Related: [ADR-0008 パッケージマネージャ・ツールバージョン管理にサプライチェーン攻撃防止のクールダウン期間を設定する](ADR-0008-configure-supply-chain-cooldown.md)

## 📄 参考資料

- [uv - Python versions (UV_PYTHON)](https://docs.astral.sh/uv/concepts/python-versions/)
- [mise - 環境変数テンプレート](https://mise.jdx.dev/configuration.html)
