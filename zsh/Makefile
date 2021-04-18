.PHONY: init
init: ~/.zshrc

~/.zshrc:
	for i in [a-z]*; do ln -svf ${PWD}/$$i ~/.$$i; done

	sudo chsh -s `which zsh` ${USER}
