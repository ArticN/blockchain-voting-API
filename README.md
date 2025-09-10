# Blockchain Voting – Dev Env (Hyperledger Fabric 2.5.x)

Ambiente de desenvolvimento do TCC usando **Hyperledger Fabric 2.5.x (LTS)** com a `test-network`.  
As dependências pesadas (binários, `fabric-samples` etc.) ficam em `./_deps/` e **não** são versionadas.

---

## TL;DR (rodar agora)


# 1) Clone
```bash
git clone https://github.com/<seu-usuario>/blockchain-voting-API.git
cd blockchain-voting-API
```
# 2) Baixar deps e preparar PATH/config
```bash
make bootstrap
source env.sh
```
# 3) Subir a rede e fazer deploy do chaincode
```bash
make up
make deploy
```
# 4) Testar (esperado: "pong")
```bash
cd _deps/fabric-samples/test-network
source scripts/envVar.sh
setGlobals 1
peer chaincode query -C mychannel -n vote -c '{"Args":["Ping"]}'
```
1) Requisitos (Linux Mint / Ubuntu)

    Docker Engine + Docker Compose (plugin v2)

    Git, curl, jq, make

    Go (opcional no host; o build roda no container; usamos go 1.20 no chaincode)

Instalação rápida

# Pacotes básicos
sudo apt update && sudo apt -y install ca-certificates curl gnupg lsb-release git jq make

# Docker oficial
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo ${UBUNTU_CODENAME:-$VERSION_CODENAME}) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker

# Usar docker sem sudo
sudo usermod -aG docker $USER
newgrp docker

    Dicas de VM: 2+ vCPUs, 6–8 GB RAM e ~15 GB livres ajudam bastante nos builds iniciais.

2) Estrutura do repositório

blockchain-voting-API/
├─ chaincode/
│  └─ vote/              # chaincode Go (método Ping → "pong")
├─ scripts/              # bootstrap / up / deploy / down
├─ Makefile              # atalhos
├─ env.sh                # PATH e FABRIC_CFG_PATH (gerado no bootstrap)
└─ _deps/                # (IGNORADO) fabric-samples, binários, etc.

    _deps/ não vai para o commit (está no .gitignore).

    env.sh deve ser executado com source env.sh em cada nova sessão do terminal.

3) Passo a passo (comandos principais)

# Baixar deps (binários + fabric-samples) e gerar env.sh
make bootstrap

# Habilitar 'peer' no PATH e configs do Fabric para esta sessão
source env.sh

# Subir a test-network e criar o canal (mychannel)
make up

# Deploy do chaincode "vote" (Go) localizado em ./chaincode/vote
make deploy

Teste rápido

cd _deps/fabric-samples/test-network
source scripts/envVar.sh
setGlobals 1
peer chaincode query -C mychannel -n vote -c '{"Args":["Ping"]}'   # -> pong

Encerrar a rede

cd ~/dev/blockchain-voting-API        # volte para a raiz do repo
make down

4) Fluxo de desenvolvimento do chaincode

    Edite o código em chaincode/vote (o go.mod já está com go 1.20).

    Rode make deploy para publicar uma nova sequence do chaincode.

    Use peer para query/invoke (sempre após source env.sh e setGlobals no terminal atual).

    O deploy já roda go mod tidy e go mod vendor dentro do chaincode.

5) Atalhos do Makefile

    make bootstrap – baixa deps (binários, fabric-samples) em _deps/ e cria env.sh.

    make up – sobe a rede e cria mychannel.

    make deploy – vendoriza, empacota e faz deploy do chaincode vote (Go).

    make down – derruba a rede.

    make clean – remove _deps/, env.sh e artefatos gerados.

6) Troubleshooting

    peer: command not found
    Rode source env.sh na raiz do repositório. Confirme com which peer.

    Permissão do Docker
    Garanta que o daemon está rodando e seu usuário está no grupo docker:

    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    newgrp docker
    docker ps

    Timeout ao instalar chaincode
    Já configurado no deploy: CORE_PEER_CLIENT_CONNTIMEOUT=120s.
    Se necessário, aumente esse valor em scripts/deploy-go.sh.

    Ambiente “sujo”
    Reinicie a rede: make down && make up.
    Para zerar tudo e refazer download: make clean && make bootstrap.

7) Clonar o repositório

# HTTPS
git clone https://github.com/<seu-usuario>/blockchain-voting-API.git
# ou via SSH
# git clone git@github.com:<seu-usuario>/blockchain-voting-API.git

cd blockchain-voting-API

    Depois do clone, siga para Passo 3 (bootstrap → env.sh → up → deploy).

8) Notas finais

    _deps/ é recriado pelos scripts — não comitar.

    O chaincode de exemplo expõe Ping() → "pong" para validar o ambiente.

    Quando quiser mudar o nome/caminho do chaincode, ajuste em scripts/deploy-go.sh (flags -ccn/-ccp) e/ou crie um target make deploy-<nome> específico.
