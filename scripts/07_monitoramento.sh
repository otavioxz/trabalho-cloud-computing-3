#!/bin/bash
# Tarefa 07 - Monitoramento do sistema
# Coleta CPU, RAM, disco e status do Apache. Emite alertas quando passam de 80%.

LOG="/app/logs/monitoramento.log"
LIMITE=80

log() {
    echo "$(date '+%F %T') - $1" >> "$LOG"
}

alerta_ou_ok() {
    # $1 = uso atual em %, $2 = recurso (CPU/RAM/DISCO)
    local uso=$1
    local recurso=$2
    if [ "$uso" -ge "$LIMITE" ]; then
        echo "[ALERTA] Uso de $recurso acima de ${LIMITE}% (atual: ${uso}%)"
        log "ALERTA $recurso=${uso}%"
    else
        echo "[OK] $recurso em ${uso}%"
    fi
}

coletar_cpu() {
    # %CPU em uso = 100 - %idle
    local idle uso
    idle=$(top -bn1 | grep -m1 "Cpu(s)" | awk -F'id,' '{print $1}' | awk '{print $NF}' | cut -d. -f1)
    [ -z "$idle" ] && idle=100
    uso=$((100 - idle))
    alerta_ou_ok "$uso" "CPU"
}

coletar_memoria() {
    local total usado uso
    total=$(free -m | awk '/^Mem:/ {print $2}')
    usado=$(free -m | awk '/^Mem:/ {print $3}')
    if [ "$total" -gt 0 ]; then
        uso=$(( usado * 100 / total ))
    else
        uso=0
    fi
    alerta_ou_ok "$uso" "RAM"
}

coletar_disco() {
    local uso
    uso=$(df -h / | awk 'NR==2 {gsub("%",""); print $5}')
    alerta_ou_ok "$uso" "DISCO"
}

verificar_apache() {
    if pgrep -x apache2 >/dev/null; then
        echo "[OK] Apache em execucao"
        log "Apache OK"
    else
        echo "[ALERTA] Apache NAO esta em execucao"
        log "ALERTA Apache parado"
    fi
}

monitorar() {
    echo "=========================================="
    echo " Monitoramento - Portal de Noticias"
    echo " Data: $(date '+%F %T')"
    echo "=========================================="
    coletar_cpu
    coletar_memoria
    coletar_disco
    verificar_apache
    echo "=========================================="
    echo ""
    echo "[DETALHES]"
    echo "- Memoria:"
    free -h
    echo "- Disco:"
    df -h /
}

mkdir -p "$(dirname "$LOG")"
monitorar
