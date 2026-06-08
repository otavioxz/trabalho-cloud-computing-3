#!/bin/bash
# Tarefa 02 - Instalação e validação do Apache
# Tema do trabalho: Portal de Notícias. Como envolve mídia (imagens em artigos),
# também garantimos a presença de imagemagick e ffmpeg, pacotes complementares.

LOG="/app/logs/apache.log"

log() {
    echo "$(date '+%F %T') - $1" >> "$LOG"
}

validar_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "[ERRO] Execute como root."
        exit 1
    fi
}

instalar_apache() {
    echo "[INFO] Instalando Apache e pacotes complementares (imagemagick, ffmpeg)..."
    if apt install -y apache2 imagemagick ffmpeg; then
        log "Apache + imagemagick + ffmpeg instalados"
    else
        log "Falha na instalacao do Apache/imagemagick/ffmpeg"
        echo "[FALHA] Erro ao instalar pacotes."
        return 1
    fi

    echo "[INFO] Iniciando servico apache2..."
    service apache2 start
    log "Servico apache2 iniciado"
}

verificar_apache() {
    echo "[INFO] Verificando se o Apache esta instalado..."
    if dpkg -l | grep -q "^ii  apache2 "; then
        echo "[OK] Apache instalado."
        log "Verificacao OK"
        return 0
    else
        echo "[FALHA] Apache NAO esta instalado."
        log "Verificacao FALHOU"
        return 1
    fi
}

versao_apache() {
    echo "[INFO] Versao do Apache:"
    apache2 -v
    log "Versao verificada: $(apache2 -v | head -n1)"
}

validar_root
mkdir -p "$(dirname "$LOG")"
instalar_apache
verificar_apache
versao_apache
