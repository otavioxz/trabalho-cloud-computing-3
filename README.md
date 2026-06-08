# Trabalho 03 - Linux, Shell Script e Cloud Computing

## Aluno
Otavio Rodrigues

## Tema
Portal de Notícias

## Descrição do Projeto
Este projeto simula a rotina de um profissional de DevOps responsável por
preparar e operar um ambiente Linux que hospeda um portal de notícias. O ambiente
roda em um container Ubuntu Server, expõe o Apache para servir o site estático
do portal e centraliza scripts Shell para atualizar o sistema, criar a estrutura
de pastas temática, publicar conteúdo, gerar backups, monitorar recursos e
controlar usuários/permissões — tarefas típicas de um cenário de Cloud Computing.

## Tecnologias Utilizadas
- Ubuntu 22.04 (container)
- Docker e Docker Compose
- Apache 2
- Shell Script (bash)
- Imagemagick e FFmpeg (pacotes complementares ao tema mídia/notícias)
- GitHub e DockerHub

## Estrutura do Projeto
```
trabalho03-scripts/
├── Dockerfile               # Imagem Ubuntu + Apache + utilitários
├── docker-compose.yml       # Orquestração + volumes persistentes
├── README.md                # Este arquivo
├── scripts/                 # 9 scripts da operação + menu principal
│   ├── 01_update.sh
│   ├── 02_apache.sh
│   ├── 03_estrutura.sh
│   ├── 04_backup.sh
│   ├── 05_deploy.sh
│   ├── 06_processos.sh
│   ├── 07_monitoramento.sh
│   ├── 08_usuarios_permissoes.sh
│   ├── 09_relatorio.sh
│   └── menu.sh
├── source/                  # Site estático do Portal de Notícias
│   ├── index.html
│   ├── sobre.html
│   └── assets/
│       └── style.css
├── backups/                 # Saída dos backups (.tar.gz)
├── logs/                    # Logs e relatório operacional
└── evidencias/              # Prints e arquivos de comprovação
```

## Como Executar

1. Clone o repositório e entre na pasta:
   ```bash
   git clone https://github.com/otavioxz/trabalho-cloud-computing-3
   cd trabalho03-scripts
   ```

2. Garanta a permissão de execução dos scripts (já vem aplicada, mas por garantia):
   ```bash
   chmod +x scripts/*.sh
   ```

3. Suba o ambiente:
   ```bash
   docker compose up -d --build
   ```

4. Entre no container:
   ```bash
   docker exec -it trabalho03-linux bash
   ```

5. Acesse os scripts:
   ```bash
   cd /app/scripts
   ./menu.sh
   ```

## Como Acessar o Apache no Navegador
Após o `docker compose up`, abra:
```
http://localhost:8080
```
O conteúdo só aparece depois que o deploy (script 05) for executado.

## Scripts Disponíveis

| Script | Descrição |
|---|---|
| `01_update.sh` | Atualiza pacotes (`apt update && apt upgrade -y`) e gera log. |
| `02_apache.sh` | Instala Apache + imagemagick + ffmpeg, valida instalação e mostra versão. |
| `03_estrutura.sh` | Cria a árvore `/app/noticias` (artigos, autores, categorias, mídias, dados, publicacao, logs, backups). |
| `04_backup.sh` | Compacta `/app/noticias` em `backup_noticias_AAAA-MM-DD_HH-MM.tar.gz` em `backups/`. |
| `05_deploy.sh` | Limpa `/var/www/html`, copia `source/` para lá e valida o `index.html`. |
| `06_processos.sh` | `listar`, `buscar <nome>` ou `matar <PID>` — exige PID e valida que ele existe. |
| `07_monitoramento.sh` | Coleta CPU/RAM/DISCO/Apache. Imprime `[ALERTA]` quando algo passa de 80% ou Apache cai. |
| `08_usuarios_permissoes.sh` | Cria grupo `noticias_ops`, usuários `jornalista` e `editor_chefe`, aplica `chown/chmod 750`. |
| `09_relatorio.sh` | Gera `logs/relatorio_execucao.txt` com data, disco, du dos diretórios, status do Apache, backups, publicação, usuários e permissões. |
| `menu.sh` | Menu interativo que orquestra todos os scripts acima. |

### Como Executar Cada Script
Dentro do container, em `/app/scripts`:
```bash
./01_update.sh
./02_apache.sh
./03_estrutura.sh
./04_backup.sh
./05_deploy.sh
./06_processos.sh listar
./06_processos.sh buscar apache
./06_processos.sh matar 1234
./07_monitoramento.sh
./08_usuarios_permissoes.sh
./09_relatorio.sh
```

### Como Executar o Menu Principal
```bash
cd /app/scripts
./menu.sh
```
O menu apresenta as 10 opções (1–9 + 0 para sair) e pode ser executado
repetidamente sem reiniciar o container.

## Sequência Recomendada de Validação
Para um teste completo, dentro do container:
```bash
cd /app/scripts
./01_update.sh
./02_apache.sh
./03_estrutura.sh
./05_deploy.sh
./08_usuarios_permissoes.sh
./04_backup.sh
./07_monitoramento.sh
./09_relatorio.sh
```
Depois abra `http://localhost:8080` no navegador e veja `logs/relatorio_execucao.txt`.

## Evidências
Prints e arquivos comprovando cada etapa estão em `evidencias/`. A lista mínima
exigida pelo enunciado:
- Container em execução (`docker ps`)
- Volume montado (`docker inspect`)
- Scripts com permissão de execução (`ls -l scripts/`)
- Execução do update (saída do `01_update.sh`)
- Apache instalado e validado (saída do `02_apache.sh`)
- Estrutura criada (`find /app/noticias`)
- Backup `.tar.gz` em `backups/`
- Deploy concluído (`ls /var/www/html`)
- Site no navegador (`http://localhost:8080`)
- Monitoramento (saída com `[OK]`/`[ALERTA]`)
- Usuários e permissões (saída do `08`)
- Relatório `logs/relatorio_execucao.txt`
- Imagem publicada no DockerHub

## DockerHub
Link da imagem publicada: `https://hub.docker.com/repository/docker/otavioxz/trabalho03-linux/general`

## Uso de Inteligência Artificial
Utilizei o Claude como apoio para revisar a estrutura dos scripts,
sugerir validações (root, idempotência, alertas de monitoramento) e melhorar a
organização do README. A lógica de cada tarefa foi revisada manualmente,
adaptada ao tema de Blog de Noticias e testada dentro do container. 
Cada script foi escrito com nomes coerentes ao tema, funções nomeadas e logs registrados de forma
explícita.

## Principais Dificuldades Encontradas
- Diferenças entre `service apache2 status` em container minimal e em uma VM completa; precisei usar `pgrep apache2` em pontos onde o status retorna saídas estranhas.
- Calcular uso real de CPU pelo `top` em modo batch dentro do container — a saída de `Cpu(s)` exige parsing pelo campo `id` (idle).
- Garantir que os scripts sejam idempotentes (rodar 2x sem falhar): `08_usuarios_permissoes.sh` agora valida se grupo/usuário já existem antes de criar.
- Evitar permissões 777: optei por 750 nos diretórios temáticos e 755 apenas em `publicacao/`, justificando no comentário do script.
