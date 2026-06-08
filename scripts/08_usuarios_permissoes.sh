#!/bin/bash
# Tarefa 08 - Usuários, grupos e permissões
# Cria grupo e usuários do Portal de Notícias, aplica chown/chmod nos diretórios.
# Permissão 750: dono e grupo têm acesso completo/leitura; "outros" não acessam,
# pois os dados editoriais não devem ficar abertos no servidor.

BASE="/app/noticias"
GRUPO="noticias_ops"
USUARIO="jornalista"
EDITOR="editor_chefe"
LOG="/app/logs/usuarios.log"

log() {
    echo "$(date '+%F %T') - $1" >> "$LOG"
}

validar_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "[ERRO] Execute como root."
        exit 1
    fi
}

criar_grupo() {
    if getent group "$GRUPO" >/dev/null; then
        echo "[INFO] Grupo $GRUPO ja existe."
    else
        groupadd "$GRUPO"
        echo "[OK] Grupo $GRUPO criado."
        log "Grupo $GRUPO criado"
    fi
}

criar_usuario() {
    local user="$1"
    if id "$user" >/dev/null 2>&1; then
        echo "[INFO] Usuario $user ja existe."
    else
        useradd -m -s /bin/bash -g "$GRUPO" "$user"
        echo "[OK] Usuario $user criado e adicionado ao grupo $GRUPO."
        log "Usuario $user criado"
    fi
}

aplicar_permissoes() {
    if [ ! -d "$BASE" ]; then
        echo "[FALHA] $BASE nao existe. Execute 03_estrutura.sh antes."
        exit 1
    fi

    echo "[INFO] Aplicando dono/grupo em $BASE..."
    chown -R "$USUARIO":"$GRUPO" "$BASE"

    echo "[INFO] Aplicando chmod 750 em $BASE (dono+grupo, sem 'outros')..."
    chmod -R 750 "$BASE"

    # Pasta de publicação precisa ser legível pelo Apache (www-data) -> 755.
    chmod 755 "$BASE/publicacao"

    echo "[OK] Permissoes aplicadas:"
    ls -ld "$BASE" "$BASE"/*

    log "Permissoes aplicadas em $BASE"
}

mkdir -p "$(dirname "$LOG")"
validar_root
criar_grupo
criar_usuario "$USUARIO"
criar_usuario "$EDITOR"
aplicar_permissoes
