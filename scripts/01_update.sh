#!/bin/bash
# Tarefa 01 - Atualização do sistema
# Atualiza os pacotes do Ubuntu do container e registra o resultado em log.

LOG="/app/logs/update.log"

validar_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "[ERRO] Este script precisa ser executado como root."
        exit 1
    fi
}

atualizar_sistema() {
    echo "[INFO] Atualizando lista de pacotes..."
    if apt update && apt upgrade -y; then
        echo "$(date '+%F %T') - Atualizacao concluida com sucesso" >> "$LOG"
        echo "[OK] Sistema atualizado."
    else
        echo "$(date '+%F %T') - Falha na atualizacao" >> "$LOG"
        echo "[FALHA] Nao foi possivel atualizar o sistema."
        exit 1
    fi
}

validar_root
mkdir -p "$(dirname "$LOG")"
atualizar_sistema
