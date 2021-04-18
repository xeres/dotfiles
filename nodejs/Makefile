.PHONY: init
init: ~/.local/share/n/bin/n

~/.local/share/n/bin/n:
	curl -L https://git.io/n-install | N_PREFIX="${HOME}/.local/share/n" SHELL=zsh bash -s -- -y -n

clean:
	rm -rf "${HOME}/.local/share/n"
