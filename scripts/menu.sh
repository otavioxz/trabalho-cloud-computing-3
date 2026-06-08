#!/bin/bash
# Menu principal do portal de Notícias
# Integra as rotinas operacionais do ambiente Linux containerizado.

cd "$(dirname "$0")" || exit 1

cabecalho() {
    clear
    echo "============================================"
    echo " Criado por : Otavio Rodrigues"
    echo " Instituicao: Unidavi"
    echo " Tema       : Portal de Noticias"
    echo "============================================"
    echo "         MENU DEVOPS"
    echo "============================================"
    echo " 1 - Atualizar sistema"
    echo " 2 - Instalar Apache"
    echo " 3 - Criar estrutura do projeto"
    echo " 4 - Realizar backup"
    echo " 5 - Fazer deploy"
    echo " 6 - Ver processos"
    echo " 7 - Monitorar sistema"
    echo " 8 - Configurar usuarios e permissoes"
    echo " 9 - Gerar relatorio"
    echo " 0 - Sair"
    echo "============================================"
}

while true; do
    cabecalho
    read -rp "Escolha uma opcao: " op

    case "$op" in
        1) ./01_update.sh ;;
        2) ./02_apache.sh ;;
        3) ./03_estrutura.sh ;;
        4) ./04_backup.sh ;;
        5) ./05_deploy.sh ;;
        6)
            echo ""
            echo "Sub-opcoes: 1) listar  2) buscar  3) matar"
            read -rp "Escolha: " sub
            case "$sub" in
                1) ./06_processos.sh listar ;;
                2) read -rp "Nome do processo: " nome; ./06_processos.sh buscar "$nome" ;;
                3) read -rp "PID: " pid; ./06_processos.sh matar "$pid" ;;
                *) echo "Opcao invalida." ;;
            esac
            ;;
        7) ./07_monitoramento.sh ;;
        8) ./08_usuarios_permissoes.sh ;;
        9) ./09_relatorio.sh ;;
        0) echo "Encerrando..."; exit 0 ;;
        *) echo "Opcao invalida." ;;
    esac

    echo ""
    read -rp "Pressione ENTER para continuar..." _
done
