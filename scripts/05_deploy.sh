#!/bin/bash
# Tarefa 05 - Deploy do site estático do Portal de Notícias
# Publica os arquivos de /app/source no diretório padrão do Apache.

ORIGEM="/app/source"
DESTINO="/var/www/html"
LOG="/app/logs/deploy.log"

log() {
    echo "$(date '+%F %T') - $1" >> "$LOG"
}

validar_origem() {
    if [ ! -f "$ORIGEM/index.html" ]; then
        echo "[FALHA] Nao encontrei $ORIGEM/index.html. Verifique a pasta source/."
        log "FALHA - source/index.html ausente"
        exit 1
    fi
}

deploy() {
    echo "[INFO] Limpando $DESTINO..."
    rm -rf "${DESTINO:?}"/*

    echo "[INFO] Copiando arquivos de $ORIGEM para $DESTINO..."
    cp -r "$ORIGEM"/* "$DESTINO"/

    echo "[INFO] Arquivos publicados:"
    ls -la "$DESTINO"

    if [ -f "$DESTINO/index.html" ]; then
        echo "[OK] Deploy concluido. Acesse http://localhost:8080"
        log "Deploy OK - $(ls "$DESTINO" | tr '\n' ' ')"
    else
        echo "[FALHA] index.html nao chegou ao destino."
        log "FALHA - index.html ausente em $DESTINO"
        exit 1
    fi
}

mkdir -p "$(dirname "$LOG")"
validar_origem
deploy
