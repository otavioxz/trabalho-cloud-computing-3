FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Pacotes do sistema:
# - apache2: servidor web do deploy
# - imagemagick / ffmpeg: pacotes complementares
# - tar, procps, sudo, nano, curl, iproute2: utilitários usados pelos scripts
RUN apt update && apt install -y \
    apache2 \
    imagemagick \
    ffmpeg \
    tar \
    procps \
    sudo \
    nano \
    curl \
    iproute2 \
    && apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY scripts /app/scripts
COPY source /app/source

RUN mkdir -p /app/logs /app/backups /app/evidencias \
    && chmod +x /app/scripts/*.sh

EXPOSE 80

CMD service apache2 start && tail -f /dev/null
