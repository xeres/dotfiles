# github.com/xeres/dotfiles

Xeres's dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

## Install

Install them with:

```shell
PATH="$HOME/.local/bin:$PATH"
sh -c "$(curl -fsLS git.io/chezmoi)" -- -b ~/.local/bin init xeres --apply
```

If you want to use `docker` with WSL 2, see also.

https://docs.docker.com/docker-for-windows/wsl/

After enabling integration, do the following:

```shell
sudo usermod -aG docker $USER
```

And restart the terminal.
