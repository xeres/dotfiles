.PHONY: build run
build:
	docker buildx build -t chezmoi-ubuntu-20.04:latest .

run:
	docker run -v ${PWD}:/home/testuser/.local/share/chezmoi -it -u testuser chezmoi-ubuntu-20.04:latest
