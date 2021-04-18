.PHONY: init
init: ~/.local/bin/aws

~/.local/bin/aws:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    	unzip awscliv2.zip && \
    	./aws/install -i ~/.local/share/aws-cli -b ~/.local/bin && \
    	rm -rf ./aws awscliv2.zip

.PHONY: update
update:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    	unzip awscliv2.zip && \
    	./aws/install -i ~/.local/share/aws-cli -b ~/.local/bin --update && \
    	rm -rf ./aws awscliv2.zip

.PHONY: clean
clean:
	rm -rf ~/.local/bin/aws{,_completer} ~/.local/share/aws-cli
