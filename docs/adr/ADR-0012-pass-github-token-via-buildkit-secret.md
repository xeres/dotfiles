---
title: ADR-0012 ローカル make test で GitHub トークンを BuildKit secret 経由で渡す
status: Accepted
date: 2026-10-07
---

# ADR-0012 ローカル make test で GitHub トークンを BuildKit secret 経由で渡す

## 🤔 背景

`make test` は Dockerfile 内で chezmoi apply を実行し、その過程で `mise install` が各ツールを GitHub から取得する。mise は未認証だと GitHub API を匿名リクエストするため、レート制限（60 req/h・IP 単位）に達すると `awscli` や `usage` などの解決・取得が 403 で失敗し、ビルドが途中で止まる。

CI（GitHub Actions）は `GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}` を chezmoi apply に渡しており、認証済みリクエストでこの問題を回避済みである。レート制限に当たるのはトークンを渡せていなかった**ローカルの Docker ビルドのみ**だった。

トークンをイメージレイヤやビルド履歴に残すと漏洩リスクがあるため、ビルド引数（`--build-arg`）での受け渡しは避けたい。

## 💡 決定事項

ローカルの `make test` では、`gh auth token` で取得した GitHub トークンを BuildKit secret（`--mount=type=secret`）として Docker ビルドに渡し、chezmoi apply 実行時のみ `GITHUB_TOKEN` 環境変数として注入する。`gh` が未インストールまたは未サインインの場合は、トークンなし（未認証・レート制限あり）でビルドする既存挙動にフォールバックする。

### 決定に至った差別化要素

BuildKit secret はビルド中のみ `/run/secrets` にマウントされ、イメージレイヤにもビルド履歴にも残らないため、トークンの漏洩リスクを避けつつレート制限を回避できる。

トークンの取得元は 1Password CLI（`op`）も検討したが、`gh auth token` を選んだ。`op read` は `op signin` 済みのセッションを前提とし、そのセッションは揮発するため `make test` のたびにログインを強いられる。`gh auth token` は一度 `gh auth login` すればログイン状態が永続し、以降の `make test` で追加操作なくトークンを取得できる。

デメリットとして、Dockerfile に secret マウント用の記述が増え、`make test` に BuildKit（`DOCKER_BUILDKIT=1`）を要求する。また `gh` 未サインイン環境ではレート制限の問題が残るが、フォールバックにより `make test` 自体は従来どおり動作する。

## 🔍 検討した選択肢

|  | トークンの秘匿性 | ログインの永続性 | 既存挙動との互換性 |
| --- | --- | --- | --- |
| gh auth token + BuildKit secret | ✅ レイヤに残らない | ✅ gh auth login 後は永続 | ✅ 未サインイン時はフォールバック |
| op read + BuildKit secret | ✅ レイヤに残らない | ❌ セッション揮発、毎回 op signin | ✅ 取得失敗時はフォールバック |
| --build-arg でトークンを渡す | ❌ 履歴に残る | — トークン取得手段に依存 | ✅ |
| トークンを渡さない（現状） | ✅ そもそも渡さない | — | ❌ レート制限で失敗 |

### 1️⃣ 1Password CLI（op）からトークンを取得する

`op read "op://<Vault>/<Item>/<field>"` でトークンを取り出し、BuildKit secret として渡す。

- ✅ トークンの秘匿性: BuildKit secret 経由でレイヤに残らない
- ❌ ログインの永続性: `op signin` のセッションは揮発するため、`make test` のたびにログインが必要になる
- ✅ 既存挙動との互換性: 取得できなければフォールバック可能

### 2️⃣ --build-arg でトークンを渡す

`docker build --build-arg GITHUB_TOKEN=...` でトークンを渡す。

- ❌ トークンの秘匿性: ビルド引数はイメージ履歴（`docker history`）に残り、漏洩リスクがある
- — ログインの永続性: トークンの取得手段に依存するため、この軸では評価しない
- ✅ 既存挙動との互換性: 引数を省けば従来どおり

### 3️⃣ トークンを渡さない（現状維持）

未認証のまま `mise install` を実行する。

- ✅ トークンの秘匿性: トークンを扱わない
- — ログインの永続性: トークンを扱わないため該当しない
- ❌ 既存挙動との互換性: レート制限に達するとビルドが失敗し、ローカルでのテストが安定しない

## 🔗 関連ADR

- Related: [ADR-0003 Docker コンテナで対話的テスト環境を構築する](ADR-0003-adopt-docker-for-interactive-testing.md)
- Related: [ADR-0009 mise のインストールを chezmoi apply で行う](ADR-0009-install-mise-via-chezmoi-apply.md)

## 📄 参考資料

- [Docker build secrets](https://docs.docker.com/build/building/secrets/)
- [mise GitHub token の設定](https://mise.jdx.dev/dev-tools/github-tokens.html)
