---
title: ADR-0014 node の gpg_verify 無効化を解除する
status: Accepted
date: 2026-10-07
---

# ADR-0014 node の gpg_verify 無効化を解除する

## 🤔 背景

以前、mise の config.toml に `[settings.node] gpg_verify = false` を設定していた（コミット `fix(mise): disable gpg_verify for Node.js`）。

当時の mise は node の OpenPGP 署名検証を外部の `gpg` コマンドに依存して行っており（現在の `node.verify` 設定に相当）、`gpg` が存在しない、あるいは keyring が壊れている環境では、警告ではなく **node のインストール自体が失敗**した（`mise ERROR gpg failed` / `failed to install core:node`）。mise 本体や他ツールは動くが node だけ入らない、という状態になる。本リポジトリは `gpg` を導入していない Docker（ubuntu:22.04）や、`gpg` の有無を保証できない多様な環境を対象とするため、インストールを通すために署名検証を無効化していた。

その後 mise は node の署名検証を**外部 `gpg` コマンドを必要としない組み込み OpenPGP 実装**（`node.gpg_verify`、"built-in, no external gpg required"）へ移行した。これにより、無効化の前提だった「外部 `gpg` 不在/破損による失敗」は発生しなくなった可能性があり、無効化を維持する必要があるか不明だった。無効化した理由自体が記録されておらず、後から追えなかったことも課題だった。

## 💡 決定事項

`[settings.node] gpg_verify = false` を削除し、node の署名検証を有効（mise のデフォルト）に戻す。

削除に先立ち、`gpg` を導入していない ubuntu:22.04 の Docker 環境で、`gpg_verify` を外した状態で `mise install node` が成功することを実検証した。node は警告もエラーもなくインストールでき、`mise install -v` のログに OpenPGP 署名パケットのパース処理が確認できたことから、外部 `gpg` なしで組み込み検証が実際に走っていることを確かめた。

### 決定に至った差別化要素

無効化の原因（外部 `gpg` 依存）が mise の組み込み検証移行で解消しており、検証を有効化してもインストールは失敗しない。本リポジトリは供給チェーン対策として cooldown を敷いており（ADR-0008）、同じ方針のもとでは配布物の真正性を担保する署名検証も有効であることが望ましい。無効化を続ける技術的理由はもう無く、外す方がセキュリティ姿勢として一貫する。

トレードオフとして、将来 mise が組み込み検証をデフォルトで行わなくなった場合や、署名検証が失敗する事象が再発した場合には、再び node のインストールが失敗しうる。その際は無効化ではなく原因（署名・鍵・mise のバージョン）の調査を優先する。本 ADR は「なぜ一度無効化し、なぜ戻したか」を記録として残し、同じ判断を繰り返し忘れないことを目的とする。

## 🔍 検討した選択肢

|  | 署名検証 | gpg なし環境での node インストール | 設定の単純さ |
| --- | --- | --- | --- |
| gpg_verify を削除（検証有効・組み込み） | ✅ 有効 | ✅ 成功（実検証済み） | ✅ 余計な設定なし |
| gpg_verify = false を維持 | ❌ 無効 | ✅ 成功 | ⚠️ 不要な上書きが残る |
| 各環境に外部 gpg を導入して検証 | ✅ 有効 | ⚠️ gpg の導入が前提 | ❌ 環境ごとの追加設定 |

### 1️⃣ gpg_verify = false を維持する

従来どおり署名検証を無効化したままにする。

- ❌ 署名検証: 無効のまま。配布物の真正性を検証しない
- ✅ gpg なし環境での node インストール: 成功する
- ⚠️ 設定の単純さ: 現在は不要になった上書きが config に残り、理由も分かりにくい

### 2️⃣ 各環境に外部 gpg を導入して検証する

Docker などに `gpg` をインストールし、外部 gpg による検証を維持する。

- ✅ 署名検証: 有効
- ⚠️ gpg なし環境での node インストール: 対象環境すべてに gpg の導入が必要
- ❌ 設定の単純さ: 組み込み検証で十分な現在、環境ごとに gpg を入れるのは過剰

## 🔗 関連ADR

- Related: [ADR-0007 ツールのインストールに原則 mise を使用する](ADR-0007-adopt-mise-for-tool-installation.md)
- Related: [ADR-0008 パッケージマネージャ・ツールバージョン管理にサプライチェーン攻撃防止のクールダウン期間を設定する](ADR-0008-configure-supply-chain-cooldown.md)

## 📄 参考資料

- [mise settings - node.gpg_verify / node.verify](https://mise.jdx.dev/configuration/settings.html)
- [volta から mise へ移行する（gpg エラーと gpg_verify=false の事例）](https://zenn.dev/otaki0413/scraps/038c7da1a1e422)
