# github.com/xeres/dotfiles

Xeres's dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

Install them with:

```shell-session
$ sh -c "$(curl -fsLS git.io/chezmoi)" -- -b ~/.local/bin
$ PATH="$HOME/.local/bin:$PATH"
$ chezmoi init xeres
$ chezmoi apply
```
