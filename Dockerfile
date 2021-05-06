FROM public.ecr.aws/ubuntu/ubuntu:20.04_stable
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl sudo && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    useradd testuser -m && \
    usermod -aG sudo testuser && \
    echo 'testuser ALL=NOPASSWD: ALL' > /etc/sudoers.d/testuser

USER testuser
ENV USER=testuser

RUN \
    sh -c "$(curl -fsLS git.io/chezmoi)" -- -b ~/.local/bin && \
    PATH="$HOME/.local/bin:$PATH" && \
    chezmoi init xeres && \
    chezmoi apply
