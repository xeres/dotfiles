# Bootstrap

## ファイル配置

- When: chezmoi apply を実行する
- Then: 管理対象の dotfiles がホームディレクトリに配置される
  (対象ファイルの一覧は `test/common/bootstrap.bats` を正とする)

## ディレクトリ構造

- When: chezmoi apply を実行する
- Then: `~/repos/works/` ディレクトリが存在する

## macOS

- When: macOS で chezmoi apply を実行する
- Then: `brew` コマンドが利用可能である
- Then: ログインシェルが zsh である

## Linux (Debian系)

- When: Debian 系 Linux で chezmoi apply を実行する
- Then: `zsh` コマンドが利用可能である
- Then: ログインシェルが zsh である
