---
title: ADR-0016 Amazon Linux 2023 を対応プラットフォームに加え CI のコンテナジョブでテストする
status: Proposed
date: 2026-11-12
---

# ADR-0016 Amazon Linux 2023 を対応プラットフォームに加え CI のコンテナジョブでテストする

## 🤔 背景

本リポジトリの対応プラットフォームは Ubuntu と macOS で、CI（ADR-0004）も `ubuntu-24.04` と `macos-26` のランナーで直接 chezmoi apply とテストを実行していた。

一方、開発用マシンとして Amazon Linux 2023 を使っている。AL2023 の `/etc/os-release` は `ID=amzn`、`ID_LIKE="fedora"` で、Debian 系の分岐に入らないため、zsh の導入もログインシェルの変更も行われていなかった。ADR-0015 で Fedora 系向けのシステムパッケージ導入を追加したが、それだけでは zsh を前提とする共通テスト（zinit、starship）は通らない。また、自動テストがないため、Fedora 系の分岐が正しく動くかを継続的に確かめる手段がなかった。

GitHub Actions には Amazon Linux のホストランナーがない。

## 💡 決定事項

Amazon Linux 2023 を対応プラットフォームに加え、CI では GitHub Actions のコンテナジョブでテストする。

- `install/fedora/zsh.sh` を追加し、`run_once_after_10-install-zsh.bash.tmpl` に Fedora 系の分岐を足す。素の AL2023 には `chsh` が無いので、`zsh` とあわせて `util-linux-user` を入れる。
- `scripts/run_test.bash` は `/etc/os-release` の `ID` と `ID_LIKE` から `ubuntu` と `fedora` を判定し、`test/fedora/` を実行する。
- `.github/workflows/test.yml` に、`container: amazonlinux:2023` で動く `test (amazonlinux-2023)` ジョブを追加する。ジョブ名は既存の `test (ubuntu-24.04)` / `test (macos-26)` に揃えて「OS 名-バージョン」とする。手順は既存の `test` ジョブと同じく、checkout、chezmoi apply、`run_test.bash` の順に実行する。
  - 素のイメージに無い git、tar、gzip、sudo、findutils は、checkout の前に `dnf` で入れる。libatomic は chezmoi apply が入れることを確かめるため、ここでは入れない。
  - bats は AL2023 の標準リポジトリに無く、`bats-action` がコンテナ内で動く保証もないので、bats-core v1.13.0 を git clone して入れる。
  - コンテナは root で動き `USER` が設定されないため、ジョブで `USER=root` を設定する。

Fedora、RHEL など AL2023 以外の Fedora 系は、同じスクリプトで動く想定だが、テストの対象外とする。サポートが終了した Amazon Linux 2（`dnf` が無い）は対象外とする。

### 決定に至った差別化要素

コンテナジョブなら、既存の Ubuntu / macOS のジョブと同じ「ランナー上で直接 chezmoi apply してテストする」形で書ける。追加の Dockerfile を保守する必要がなく、`run_test.bash` もそのまま使える。素の `amazonlinux:2023` イメージから始めるので、実際の AL2023 マシンで足りないもの（今回の libatomic、`chsh` など）をテストで検出できる。

トレードオフは次の 3 点である。

- `actions/checkout` などの JavaScript アクションは、ランナーの node をコンテナ内で実行する。将来その node が素の AL2023 に無いライブラリ（libatomic など）を必要とするようになると、checkout の段階でジョブが落ちる。その場合は「Install prerequisites」のステップに追加するが、libatomic を入れるとそのテストの意味が弱くなる。
- CI は root で実行されるため、一般ユーザーでの `sudo` や `chsh` の動作は CI では確認できない。
- ローカルで同じテストを実行する手段（`make test` 相当）は用意していない。

## 🔍 検討した選択肢

|  | 既存ジョブとの書き方の一貫性 | 保守するファイル | ローカルでの再現 | 一般ユーザーでの検証 |
| --- | --- | --- | --- | --- |
| コンテナジョブ（container: amazonlinux:2023） | ✅ 同じ手順 | ✅ workflow のみ | ⚠ 手動で docker run | ❌ root で実行 |
| ubuntu ランナー上で AL2023 用 Dockerfile をビルド | ⚠ docker build 経由 | ❌ Dockerfile が増える | ✅ make で再現 | ✅ testuser で実行 |
| Fedora 系を対応対象にしない | - | ✅ 変更なし | - | - |

### 1⃣ ubuntu ランナー上で AL2023 用の Dockerfile をビルドしてテストする

`make test` と同じく、AL2023 用の Dockerfile を用意し、CI で `docker build` してからイメージ内で `run_test.bash` を実行する。

- ⚠ 既存ジョブとの書き方の一貫性: ランナー上で直接 apply する既存ジョブと手順が異なる
- ❌ 保守するファイル: Ubuntu 用と AL2023 用の Dockerfile を両方保守する必要がある
- ✅ ローカルでの再現: Makefile のターゲットを足せば同じコマンドで再現できる
- ✅ 一般ユーザーでの検証: Dockerfile で testuser を作り、一般ユーザーとして apply できる

### 2⃣ Fedora 系を対応対象にしない

AL2023 は手動でセットアップし、リポジトリでは扱わない。

- ❌ 開発用マシンで使っている環境を dotfiles で再現できない
- ❌ ADR-0015 で追加した Fedora 系の分岐が検証されないまま残る

## 🔗 関連ADR

- Related: [ADR-0004 bats による非対話的テスト(CI)を採用する](ADR-0004-adopt-bats-for-ci-testing.md)
- Related: [ADR-0005 ログインシェルとして zsh を採用する](ADR-0005-adopt-zsh-for-login-shell.md)
- Related: [ADR-0011 spec とテストを 1:1 で対応させる](ADR-0011-align-specs-with-tests-one-to-one.md)
- Related: [ADR-0015 mise ツールが必要とするシステムパッケージを OS ファミリーごとの install スクリプトで導入する](ADR-0015-install-system-packages-per-os-family.md)

## 📄 参考資料

- [GitHub Actions - Running jobs in a container](https://docs.github.com/en/actions/writing-workflows/choosing-where-your-workflow-runs/running-jobs-in-a-container)
- [Amazon Linux 2 FAQs（サポート終了日）](https://aws.amazon.com/amazon-linux-2/faqs/)
