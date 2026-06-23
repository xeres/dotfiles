DOCKER_IMAGE_NAME=dotfiles
DOCKER_USER=testuser

.PHONY: docker
docker:
	docker build --tag $(DOCKER_IMAGE_NAME) .
	docker run --interactive --tty \
		-v "$${PWD}:/home/$(DOCKER_USER)/.local/share/chezmoi" \
		--hostname $(DOCKER_IMAGE_NAME)-hostname \
		$(DOCKER_IMAGE_NAME)
