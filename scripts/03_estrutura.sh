#!/bin/bash
# Tarefa 03 - Estrutura de diretórios temática
# Cria a hierarquia de pastas usada pelo Portal de Notícias dentro do container.

BASE="/app/noticias"
LOG="/app/logs/estrutura.log"

log() {
    echo "$(date '+%F %T') - $1" >> "$LOG"
}

remover_estrutura_antiga() {
    # Só remove se realmente for o diretório esperado, evitando rm -rf perigoso.
    if [ -d "$BASE" ]; then
        echo "[INFO] Removendo estrutura antiga em $BASE..."
        rm -rf "${BASE:?}"/*
        log "Estrutura antiga removida"
    fi
}

criar_estrutura() {
    echo "[INFO] Criando estrutura tematica do Portal de Noticias..."

    # Dados temáticos
    mkdir -p "$BASE/artigos"
    mkdir -p "$BASE/autores"
    mkdir -p "$BASE/categorias"
    mkdir -p "$BASE/midias"

    # Pastas operacionais
    mkdir -p "$BASE/dados"
    mkdir -p "$BASE/publicacao"
    mkdir -p "$BASE/logs"
    mkdir -p "$BASE/backups"

    # Arquivos iniciais
    echo "Titulo: Bem-vindo ao Portal" > "$BASE/artigos/noticia_01.txt"
    echo "Autor: Equipe Editorial"     > "$BASE/autores/autor_01.txt"
    echo "Categoria: Tecnologia"       > "$BASE/categorias/categoria_01.txt"

    echo "[OK] Estrutura criada em $BASE"
    log "Estrutura criada: $(find "$BASE" -maxdepth 1 -type d | tr '\n' ' ')"

    echo ""
    echo "[INFO] Arvore criada:"
    find "$BASE" -maxdepth 2
}

mkdir -p "$(dirname "$LOG")"
remover_estrutura_antiga
criar_estrutura
