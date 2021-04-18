.PHONY: init

init:
	git clone https://github.com/pyenv/pyenv ~/.local/share/pyenv
	pyenv install 3.8.2
	pyenv global 3.8.2

clean:
	rm -rf $(pyenv root)
