.PHONY: init
init: ~/.local/bin/diff-highlight ~/.gitconfig

~/.gitconfig:
	for i in [a-z]*; do ln -svf ${PWD}/$$i ~/.$$i; done

~/.local/bin/diff-highlight:
	[ -f /usr/share/doc/git/contrib/diff-highlight/diff-highlight ] && \
		mkdir -p "${HOME}/.local/bin" && \
		cp -f /usr/share/doc/git/contrib/diff-highlight/diff-highlight "${HOME}/.local/bin" && \
		chmod +x "${HOME}/.local/bin/diff-highlight"
