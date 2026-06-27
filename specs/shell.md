# Shell

## プラグインマネージャ

- When: zsh を起動する
- Then: zinit がロードされる

## プロンプト

- When: zsh を起動する
- Then: starship が初期化される
- Then: transient prompt が有効である (CI 検証困難のため テスト省略)

## PATH

- When: zsh を起動する
- Then: `~/.local/bin` が PATH に含まれる
- Then: `~/.local/share/mise/shims` が PATH に含まれる
