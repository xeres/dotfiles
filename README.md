# dotfiles

dotfiles for Ubuntu and macOS, with partial support for Fedora-based Linux.

## Supported platforms

| Platform | Status |
|---|---|
| macOS | Supported (tested in CI) |
| Ubuntu / Debian-based | Supported (tested in CI and Docker) |
| Fedora-based (Fedora, RHEL, Amazon Linux 2023, etc.) | Partial: installs system packages required by mise tools (e.g. `libatomic`). zsh is not installed or set as the login shell. Not tested in CI. |

## Concepts

- **chezmoi** for declarative dotfiles management with templates to absorb OS differences
- **zsh** + **zinit** for a fast, extensible shell environment
- **mise** for unified tool version management (language runtimes, CLI tools, etc.)
- **Supply chain defense** — 7-day cooldown on package installations
- **Docker** for interactive testing and **bats** for CI automated tests

## Setup

```bash
PATH="$HOME/.local/bin:$PATH"
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply xeres --exclude=encrypted
```

## Test

```bash
# Ubuntu (Docker)
make test

# macOS (local)
./scripts/run_test.bash
```

## License

[MIT](LICENSE)
