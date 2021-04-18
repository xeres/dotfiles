.PHONY: init
init: ~/.local/share/pyenv/bin/pyenv

~/.local/share/pyenv/bin/pyenv:
	git clone https://github.com/pyenv/pyenv ~/.local/share/pyenv

	# AWS Lambda runtime python3.8
	pyenv install 3.8.8
	pyenv global 3.8.8

clean:
	rm -rf $(pyenv root)
