#!/bin/bash
# Tarefa 09 - Relatório operacional automatizado
# Consolida em logs/relatorio_execucao.txt um snapshot do ambiente.

ARQ="/app/logs/relatorio_execucao.txt"
ALUNO="Otavio Rodrigues"
TEMA="Portal de Noticias"
INSTITUICAO="Unidavi"
BASE="/app/noticias"

secao() {
    echo "" >> "$ARQ"
    echo "------------------------------------------------------------" >> "$ARQ"
    echo ">>> $1" >> "$ARQ"
    echo "------------------------------------------------------------" >> "$ARQ"
}

gerar_relatorio() {
    mkdir -p "$(dirname "$ARQ")"

    {
        echo "============================================================"
        echo " RELATORIO OPERACIONAL"
        echo "============================================================"
        echo " Aluno      : $ALUNO"
        echo " Instituicao: $INSTITUICAO"
        echo " Tema       : $TEMA"
        echo " Gerado em  : $(date '+%F %T')"
        echo "============================================================"
    } > "$ARQ"

    secao "Espaco em disco"
    df -h >> "$ARQ"

    secao "Uso dos diretorios do projeto"
    du -sh /app/noticias /app/backups /app/logs /app/source /var/www/html 2>/dev/null >> "$ARQ"

    secao "Status do Apache"
    if pgrep -x apache2 >/dev/null; then
        echo "[OK] Apache em execucao" >> "$ARQ"
    else
        echo "[ALERTA] Apache parado" >> "$ARQ"
    fi
    service apache2 status 2>&1 | head -n 20 >> "$ARQ"

    secao "Ultimos backups (top 5)"
    ls -lht /app/backups 2>/dev/null | head -n 6 >> "$ARQ"

    secao "Arquivos publicados em /var/www/html"
    ls -lh /var/www/html >> "$ARQ"

    secao "Logs disponiveis"
    ls -lh /app/logs >> "$ARQ"

    secao "Usuarios e grupo do projeto"
    getent group noticias_ops >> "$ARQ" 2>/dev/null
    getent passwd jornalista  >> "$ARQ" 2>/dev/null
    getent passwd editor_chefe >> "$ARQ" 2>/dev/null

    secao "Permissoes dos diretorios principais"
    if [ -d "$BASE" ]; then
        ls -ld "$BASE" "$BASE"/* >> "$ARQ"
    else
        echo "(estrutura $BASE ainda nao foi criada)" >> "$ARQ"
    fi

    echo ""
    echo "[OK] Relatorio gerado em: $ARQ"
}

gerar_relatorio
