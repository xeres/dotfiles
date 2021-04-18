.PHONY: init
init: ~/.local/share/pyenv/bin/pyenv

~/.local/share/pyenv/bin/pyenv:
	# SEE ALSO: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
	sudo apt-get install -y --no-install-recommends \
		make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
		libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev \
		libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
	git clone https://github.com/pyenv/pyenv ~/.local/share/pyenv

	# AWS Lambda runtime python3.8
	pyenv install 3.8.8
	pyenv global 3.8.8

clean:
	rm -rf $(pyenv root)
