---
title: ADR-0010 secrets 管理に age 暗号化を採用する
status: Accepted
date: 2026-06-27
---

# ADR-0010 secrets 管理に age 暗号化を採用する

## 🤔 背景

dotfiles リポジトリには SSH 鍵、API トークン、仕事用の .gitconfig など、公開リポジトリにそのまま置けないファイルが含まれる。これらを安全にバージョン管理しつつ、鍵がない環境（CI、新規マシンの初期セットアップ時）でもエラーなく基本設定を展開できる仕組みが必要になる。

## 💡 決定事項

chezmoi のネイティブ暗号化機能を用いて、age で secrets を暗号化しリポジトリに格納する。鍵がない環境では `--exclude=encrypted` を指定し、暗号化ファイルをスキップして残りの設定を正常に適用する（グレースフルデグラデーション）。

### 決定に至った差別化要素

age はシングルバイナリで動作し、GPG のような鍵サーバーや web of trust の概念がない。鍵ファイル 1 つ（identity file）と公開鍵文字列 1 つ（recipient）で暗号化・復号が完結するため、個人の dotfiles 管理において鍵管理の複雑さが最小限になる。

chezmoi が age をネイティブサポートしており、`.chezmoi.toml` に 3 行追加するだけで透過的な暗号化・復号が有効になる。暗号化対象ファイルの追加も `chezmoi add --encrypt` で完結し、ワークフローへの影響がほとんどない。

デメリットとして、age の identity file（秘密鍵）自体は暗号化リポジトリの外で安全に管理・配布する必要がある。新しいマシンへのセットアップ時に鍵ファイルを手動で配置する手順が 1 つ増える。

## 🔍 検討した選択肢

|  | 鍵管理の単純さ | chezmoi 統合 | 追加依存 | secrets のバージョン管理 |
| --- | --- | --- | --- | --- |
| age | ✅ ファイル1つ | ✅ ネイティブ | ✅ シングルバイナリ | ✅ リポジトリ内で完結 |
| GPG | ❌ 鍵リング・信頼モデル | ✅ ネイティブ | ⚠️ gpg + gpg-agent | ✅ リポジトリ内で完結 |
| 1Password CLI | ✅ マスターパスワード1つ | ⚠️ テンプレート経由 | ❌ 1Password 契約 + CLI | ❌ 外部サービス依存 |

### 1️⃣ GPG

chezmoi がネイティブサポートする暗号化方式。広く使われており実績がある。

- ❌ 鍵管理の単純さ: 鍵リング、信頼レベル、有効期限、サブキーなど概念が多い。個人利用には過剰
- ✅ chezmoi 統合: age と同様にネイティブサポート
- ⚠️ 追加依存: gpg 本体に加え gpg-agent の設定が必要。環境によっては pinentry の問題が発生する
- ✅ secrets のバージョン管理: 暗号化ファイルをリポジトリに格納できる

### 2️⃣ 1Password CLI

1Password に secrets を保存し、chezmoi テンプレートから `op read` で取得する方式。

- ✅ 鍵管理の単純さ: マスターパスワード（+ 生体認証）で完結
- ⚠️ chezmoi 統合: テンプレート内で `onepasswordRead` 関数を使う必要があり、ファイル単位の暗号化より記述が煩雑
- ❌ 追加依存: 1Password アカウント（有料）と CLI ツールが必要。オフライン環境では動作しない
- ❌ secrets のバージョン管理: secrets の実体は 1Password 側にあり、リポジトリだけではバージョン管理が完結しない

## 🔗 関連ADR

- Related: [ADR-0001 chezmoi を dotfiles 管理ツールとして採用する](ADR-0001-adopt-chezmoi-for-dotfiles-management.md)

## 📄 参考資料

- [age 公式リポジトリ](https://github.com/FiloSottile/age)
- [chezmoi 暗号化ドキュメント](https://www.chezmoi.io/user-guide/encryption/)
