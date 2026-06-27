# Bootstrap

## ファイル配置

- When: chezmoi apply を実行する
- Then: `~/.zshrc` が配置される
- Then: `~/.zshenv` が配置される
- Then: `~/.gitconfig` が配置される
- Then: `~/.npmrc` が配置される
- Then: `~/.vimrc` が配置される
- Then: `~/.config/mise/config.toml` が配置される
- Then: `~/.config/uv/uv.toml` が配置される

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
