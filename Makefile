DOCKER_IMAGE_NAME=dotfiles
DOCKER_USER=testuser

# Resolve a GitHub token via the gh CLI (`gh auth token`) and pass it to the
# build as a BuildKit secret, so `mise install` makes authenticated GitHub API
# requests and avoids the unauthenticated rate limit. If gh is unavailable or
# not signed in, fall back to building without a token (unauthenticated,
# rate-limited). The token is never written to an image layer or build history.
define docker_build
	@if command -v gh >/dev/null 2>&1 && gh auth token >/dev/null 2>&1; then \
		echo "Building with GitHub token from gh CLI"; \
		gh auth token | DOCKER_BUILDKIT=1 docker build \
			--secret id=github_token,src=/dev/stdin \
			--tag $(DOCKER_IMAGE_NAME) . ; \
	else \
		echo "gh unavailable or not signed in; building without GitHub token (rate-limited)"; \
		DOCKER_BUILDKIT=1 docker build --tag $(DOCKER_IMAGE_NAME) . ; \
	fi
endef

.PHONY: docker
docker:
	$(docker_build)
	docker run --interactive --tty \
		-v "$${PWD}:/home/$(DOCKER_USER)/.local/share/chezmoi" \
		--hostname $(DOCKER_IMAGE_NAME)-hostname \
		$(DOCKER_IMAGE_NAME)

.PHONY: test
test:
	$(docker_build)
	docker run --rm $(DOCKER_IMAGE_NAME) /home/$(DOCKER_USER)/.local/share/chezmoi/scripts/run_test.bash
