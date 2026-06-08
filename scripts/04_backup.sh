#!/bin/bash
# Tarefa 04 - Backup automatizado
# Empacota a pasta de dados do Portal de Notícias em um .tar.gz datado.

ORIGEM="/app/noticias"
DESTINO="/app/backups"
DATA=$(date +"%Y-%m-%d_%H-%M")
ARQUIVO="$DESTINO/backup_noticias_${DATA}.tar.gz"
LOG="/app/logs/backup.log"

log() {
    echo "$(date '+%F %T') - $1" >> "$LOG"
}

validar_origem() {
    if [ ! -d "$ORIGEM" ]; then
        echo "[FALHA] Diretorio de origem '$ORIGEM' nao existe. Execute 03_estrutura.sh antes."
        log "FALHA - origem $ORIGEM inexistente"
        exit 1
    fi
}

executar_backup() {
    mkdir -p "$DESTINO"
    echo "[INFO] Gerando backup de $ORIGEM em $ARQUIVO..."

    if tar -czf "$ARQUIVO" -C "$(dirname "$ORIGEM")" "$(basename "$ORIGEM")"; then
        if [ -s "$ARQUIVO" ]; then
            echo "[OK] Backup gerado: $ARQUIVO ($(du -h "$ARQUIVO" | cut -f1))"
            log "Backup OK: $ARQUIVO"
        else
            echo "[FALHA] Arquivo de backup ficou vazio."
            log "FALHA - arquivo vazio"
            exit 1
        fi
    else
        echo "[FALHA] tar retornou erro."
        log "FALHA - tar com erro"
        exit 1
    fi
}

mkdir -p "$(dirname "$LOG")"
validar_origem
executar_backup
