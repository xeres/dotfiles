---
title: ADR-0015 mise ツールが必要とするシステムパッケージを OS ファミリーごとの install スクリプトで導入する
status: Proposed
date: 2026-11-12
---

# ADR-0015 mise ツールが必要とするシステムパッケージを OS ファミリーごとの install スクリプトで導入する

## 🤔 背景

`mise upgrade` で node を 26.13.0 に更新したところ、`error while loading shared libraries: libatomic.so.1: cannot open shared object file` で node が起動しなくなった。mise が導入する node は nodejs.org の公式ビルド済みバイナリで、Linux 版は `libatomic.so.1` を動的リンクしている。最小構成の Linux には `libatomic` が入っていないことがある。

本リポジトリにはこれまで、mise のツールが必要とするシステムパッケージを導入する仕組みがなかった。OS ごとの処理は `install/ubuntu/zsh.sh` だけで、Linux の分岐も Debian 系だけだった。

テストでもこの問題を検出できなかった。Docker テスト環境（ADR-0003）の Dockerfile は `build-essential` を入れており、gcc の依存で `libatomic1` も入っていたためである。`build-essential` は Dockerfile を追加した最初のコミットから入っていて、理由は記録されていない。その時点のリポジトリには、コンパイルが必要なものはなかった。`build-essential` を外して `make test` を実行すると、`mise install` が node の段階で上記のエラーにより失敗し、問題を再現できた。node 以外の 11 ツールはコンパイラなしで導入できた。

## 💡 決定事項

mise のツールが必要とするシステムパッケージは、OS ファミリーごとの install スクリプトで導入する。

- `home/.chezmoiscripts/run_onchange_after_15-install-packages.bash.tmpl` で OS ファミリーを判定し、該当する install スクリプトを include する。
  - Debian 系（`id` または `idLike` が `debian`）: `install/ubuntu/packages.sh`（`apt-get install libatomic1`）
  - Fedora 系（`id` が `fedora`、または `idLike` に `fedora` を含む。Fedora、RHEL、Amazon Linux 2023 など）: `install/fedora/packages.sh`（`dnf install libatomic`）
  - macOS では何もしない。macOS 版の node は libatomic に依存しない。
- 番号を 15 にして、mise を導入する `20-install-mise` より前に実行する。
- `run_onchange` にして、パッケージを追加したときは既存マシンでも再実行されるようにする。

あわせて、Docker テスト環境から `build-essential` を外す。テスト環境を素の OS に近づけ、システムライブラリの不足をテストで検出できるようにするためである。

### 決定に至った差別化要素

OS 依存の処理は chezmoi テンプレートで分岐し、本体は `install/<os>/` に置くという既存の構成（zsh、brew）に合わせられる。zsh の導入とは目的が違うので、スクリプトを分けておけば、それぞれの単位が明確になる。`run_onchange` なので、今回の libatomic のように後から必要になったパッケージも、既存マシンに反映できる。将来 mise のツールが別の共有ライブラリを必要としたときも、同じ場所に追記すればよい。

トレードオフは次の 2 点である。

- `sudo` が必要なスクリプトが 1 つ増える。パッケージの一覧を変更した後の chezmoi apply では、パスワードを求められることがある。
- `build-essential` を外したので、ネイティブアドオンを含む npm パッケージや、sdist しかない Python パッケージは、Docker テスト環境ではビルドできない。dotfiles の bootstrap 自体はこれらに依存していない。

## 🔍 検討した選択肢

|  | 既存構成との一貫性 | 既存マシンへの反映 | Fedora 系への対応 |
| --- | --- | --- | --- |
| OS ごとの packages スクリプトを新設（15） | ✅ テンプレート分岐 + install/<os>/ | ✅ run_onchange で再実行 | ✅ 分岐を追加 |
| install/common/mise.sh 内で OS を判定 | ❌ common に OS 依存処理が入る | ✅ run_onchange で再実行 | ⚠ スクリプト内で判定が必要 |
| install/ubuntu/zsh.sh に追記 | ⚠ 目的の違う処理が混ざる | ❌ run_once のため再実行されない | ❌ Debian 系のみ |

### 1⃣ install/common/mise.sh 内で OS を判定する

mise を導入するスクリプトの中で OS を判定し、パッケージを入れる。

- ❌ 既存構成との一貫性: `common` に OS 依存の処理が入り、テンプレートで分岐する方針と合わない
- ✅ 既存マシンへの反映: mise の config.toml が変わったときに再実行される
- ⚠ Fedora 系への対応: シェルスクリプト内で `/etc/os-release` を読んで判定する必要がある

### 2⃣ install/ubuntu/zsh.sh に追記する

既存の zsh 導入スクリプトに `libatomic1` を足す。

- ⚠ 既存構成との一貫性: 「zsh のログインシェル化」という単位が崩れる
- ❌ 既存マシンへの反映: `run_once` なので、すでに apply 済みのマシンでは再実行されない
- ❌ Fedora 系への対応: Debian 系にしか適用されない

## 🔗 関連ADR

- Related: [ADR-0003 Docker コンテナで対話的テスト環境を構築する](ADR-0003-adopt-docker-for-interactive-testing.md)
- Related: [ADR-0007 ツールのインストールに原則 mise を使用する](ADR-0007-adopt-mise-for-tool-installation.md)
- Related: [ADR-0009 mise のインストールを chezmoi apply で行う](ADR-0009-install-mise-via-chezmoi-apply.md)
- Related: [ADR-0016 Amazon Linux 2023 を対応プラットフォームに加え CI のコンテナジョブでテストする](ADR-0016-support-amazon-linux-2023-with-ci-container-job.md)

## 📄 参考資料

- [chezmoi - Use scripts to perform actions](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
