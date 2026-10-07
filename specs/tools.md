# Tools

## mise

- When: chezmoi apply を実行する
- Then: `mise` コマンドが利用可能である

## Node.js

- When: mise install が完了する
- Then: `node` コマンドが利用可能である
- Then: `npm` コマンドが利用可能である

## uv

- When: mise install が完了する
- Then: `uv` コマンドが利用可能である

## Python

- When: mise install が完了する
- Then: `python` コマンドが利用可能である
- Then: `UV_PYTHON` が mise の python パスを指す
- Then: `uv` が mise 管理の python 実体を使用する

## GitHub CLI

- When: mise install が完了する
- Then: `gh` コマンドが利用可能である

## AWS CLI

- When: mise install が完了する
- Then: `aws` コマンドが利用可能である

## Starship

- When: mise install が完了する
- Then: `starship` コマンドが利用可能である
