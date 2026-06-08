#!/bin/bash
# Tarefa 06 - Gerenciamento de processos
# Lista, busca e encerra processos do ambiente do Portal de Notícias.

LOG="/app/logs/processos.log"

log() {
    echo "$(date '+%F %T') - $1" >> "$LOG"
}

listar_processos() {
    echo "[INFO] Processos ativos:"
    ps aux --sort=-%cpu | head -n 20
    log "listar_processos executado"
}

buscar_processo() {
    local termo="$1"
    if [ -z "$termo" ]; then
        echo "[ERRO] Informe um nome para busca. Ex.: ./06_processos.sh buscar apache"
        exit 1
    fi
    echo "[INFO] Resultado da busca por '$termo':"
    # grep -v grep evita listar o próprio processo de busca.
    ps aux | grep -i "$termo" | grep -v grep
    log "buscar_processo '$termo'"
}

matar_processo() {
    local pid="$1"
    if [ -z "$pid" ]; then
        echo "[ERRO] Informe um PID. Ex.: ./06_processos.sh matar 1234"
        exit 1
    fi

    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo "[ERRO] PID invalido: '$pid'"
        exit 1
    fi

    if ! kill -0 "$pid" 2>/dev/null; then
        echo "[ERRO] PID $pid nao existe ou voce nao tem permissao."
        log "matar_processo $pid - inexistente"
        exit 1
    fi

    echo "[ATENCAO] Encerrando PID $pid..."
    kill -15 "$pid" 2>/dev/null
    sleep 1
    if kill -0 "$pid" 2>/dev/null; then
        echo "[INFO] Processo nao respondeu ao SIGTERM, forcando SIGKILL..."
        kill -9 "$pid"
    fi
    echo "[OK] Processo $pid encerrado."
    log "matar_processo $pid - encerrado"
}

mkdir -p "$(dirname "$LOG")"

case "$1" in
    listar) listar_processos ;;
    buscar) buscar_processo "$2" ;;
    matar)  matar_processo "$2" ;;
    *)
        echo "Uso:"
        echo "  ./06_processos.sh listar"
        echo "  ./06_processos.sh buscar <nome>"
        echo "  ./06_processos.sh matar <pid>"
        ;;
esac
