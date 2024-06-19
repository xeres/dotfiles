# syntax = docker/dockerfile:1.3-labs
FROM public.ecr.aws/ubuntu/ubuntu:24.04_stable
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN <<__EOF__
apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends --no-install-suggests \
    git curl sudo file ca-certificates \
    build-essential
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
useradd testuser -m
usermod -aG sudo testuser
echo 'testuser ALL=NOPASSWD: ALL' > /etc/sudoers.d/testuser
__EOF__

USER testuser
ENV \
    USER=testuser \
    SHELL=/bin/bash
WORKDIR /home/testuser

RUN <<__EOF__
PATH="$HOME/.local/bin:$PATH"
sh -c "$(curl -fsLS git.io/chezmoi)" -- -b ~/.local/bin init

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
__EOF__

CMD [ "bash", "-i", "-l" ]
