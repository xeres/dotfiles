# Security

## サプライチェーン cooldown

- When: chezmoi apply を実行する
- Then: mise の minimum_release_age が "7d" に設定されている
- Then: npm の min-release-age が 7 に設定されている
- Then: uv の exclude-newer が "7 days" に設定されている

## secrets 管理

- When: 鍵なし環境で chezmoi apply --exclude=encrypted を実行する
- Then: 暗号化ファイルがスキップされエラーにならない (CI 自体が鍵なし実行で検証済みのためテスト省略)

## Git ワークスペース分離

- When: chezmoi apply を実行する
- Then: .gitconfig に ~/repos/works/ に対する includeIf が設定されている
