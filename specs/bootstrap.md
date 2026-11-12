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
- Then: `libatomic1` パッケージがインストールされている
  (mise で入れる node の公式 Linux ビルドが `libatomic.so.1` を動的リンクするため)
- Then: `libatomic.so.1` が動的リンカから解決できる

## Linux (Fedora系)

- When: Fedora 系 Linux (Fedora / RHEL / Amazon Linux 2023 など) で chezmoi apply を実行する
- Then: `zsh` コマンドが利用可能である
- Then: ログインシェルが zsh である
- Then: `libatomic` パッケージがインストールされている
  (mise で入れる node の公式 Linux ビルドが `libatomic.so.1` を動的リンクするため)
- Then: `libatomic.so.1` が動的リンカから解決できる
  (CI では Amazon Linux 2023 で検証する)
