.PHONY: build run
build:
	docker build -t chezmoi-ubuntu-20.04:latest .

run:
	docker run -it -u testuser chezmoi-ubuntu-20.04:latest /usr/bin/zsh --interactive
