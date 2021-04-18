.PHONY: init
init: ~/.local/bin/aws

~/.local/bin/aws:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
		unzip awscliv2.zip && \
		./aws/install -i ~/.local/share/aws-cli -b ~/.local/bin && \
		rm -rf ./aws awscliv2.zip
	curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
		dpkg-deb -x session-manager-plugin.deb session-manager-plugin && \
		cp session-manager-plugin/usr/local/sessionmanagerplugin/bin/session-manager-plugin ~/.local/bin && \
		rm -rf session-manager-plugin.deb session-manager-plugin

.PHONY: update
update:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
		unzip awscliv2.zip && \
		./aws/install -i ~/.local/share/aws-cli -b ~/.local/bin --update && \
		rm -rf ./aws awscliv2.zip
	curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
		dpkg-deb -x session-manager-plugin.deb session-manager-plugin && \
		cp session-manager-plugin/usr/local/sessionmanagerplugin/bin/session-manager-plugin ~/.local/bin && \
		rm -rf session-manager-plugin.deb session-manager-plugin

.PHONY: clean
clean:
	rm -rf ~/.local/bin/aws{,_completer} ~/.local/share/aws-cli \
		~/.local/bin/session-manager-plugin
