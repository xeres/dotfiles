# dotfiles

dotfiles for Ubuntu, Amazon Linux 2023 and macOS.

## Supported platforms

| Platform | Status |
|---|---|
| macOS | Supported (tested in CI) |
| Ubuntu / Debian-based | Supported (tested in CI and Docker) |
| Amazon Linux 2023 | Supported (tested in CI) |
| Other Fedora-based (Fedora, RHEL, etc.) | Should work via the same scripts as Amazon Linux 2023. Not tested. |

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
