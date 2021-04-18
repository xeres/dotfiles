.PHONY: init
init: system zsh git misc tmux python aws

.PHONY: system
system:
	if [ ! -x /usr/bin/zip ]; then cd system && sudo make init; fi

.PHONY: zsh
zsh:
	cd zsh && make init

.PHONY: git
git:
	cd git && make init

.PHONY: misc
misc:
	cd misc && make init

.PHONY: tmux tmux-init tmux-clean
tmux: tmux-init
tmux-init:
	cd tmux && make init

tmux-clean:
	cd tmux && make clean

.PHONY: python python-init python-clean
python: python-init
python-init:
	cd python && make init

python-clean:
	cd python && make clean

.PHONY: aws aws-init aws-update aws-clean
aws: aws-init
aws-init:
	cd aws && make init

aws-update:
	cd aws && make update

aws-clean:
	cd aws && make clean
