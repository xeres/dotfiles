.PHONY: init
init: ~/.tmux.conf

~/.tmux.conf:
	for i in [a-z]*; do ln -svf ${PWD}/$$i ~/.$$i; done
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	cat /dev/null | tmux -C
	tmux run-shell ~/.tmux/plugins/tpm/bindings/install_plugins

clean:
	rm -rf ~/.tmux.conf ~/.tmux/
