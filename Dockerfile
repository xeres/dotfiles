# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ARG USER=testuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV \
    TZ=Asia/Tokyo

RUN <<-__EOF__
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
    apt-get update
    apt-get install -y --no-install-recommends \
        curl \
        git \
        bats \
        sudo \
        tzdata \
        build-essential \
        ca-certificates
    groupadd --gid $USER_GID $USER
    useradd --uid $USER_UID --gid $USER_GID -m $USER -G sudo -s /bin/bash
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
__EOF__

USER $USER
ENV \
    USER=$USER

WORKDIR /home/$USER
COPY --chown=$USER:$USER . /home/$USER/.local/share/chezmoi

RUN <<-__EOF__
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin apply
__EOF__

CMD [ "bash", "--login" ]
