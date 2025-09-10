BLOCKCHAIN VOTING – DEV ENV (HYPERLEDGER FABRIC 2.5.X)
===========================================================

Resumo
------
Ambiente de desenvolvimento para o TCC usando Hyperledger Fabric 2.5.x (LTS) com a test-network.
As dependências pesadas (binários do Fabric, scripts oficiais e fabric-samples) ficam em ./_deps/ e NÃO são versionadas.
O código do chaincode e os scripts deste repositório são versionados normalmente.

1) REQUISITOS (Linux Mint / Ubuntu)
-----------------------------------
- Docker Engine + Docker Compose (plugin v2)
- Git, curl, jq, make
- Go (opcional no host; o build roda em container; o chaincode usa go 1.20)
- Recomendação de VM: 2+ vCPUs, 6–8 GB de RAM, ~15 GB livres em disco

Instalação rápida dos requisitos (Mint/Ubuntu):
  sudo apt update && sudo apt -y install ca-certificates curl gnupg lsb-release git jq make
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo ${UBUNTU_CODENAME:-$VERSION_CODENAME}) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl enable --now docker
  sudo usermod -aG docker $USER
  newgrp docker

2) COMO CLONAR O REPOSITÓRIO
----------------------------
HTTPS:
  git clone https://github.com/<seu-usuario>/blockchain-voting-API.git
  cd blockchain-voting-API

SSH (opcional):
  git clone git@github.com:<seu-usuario>/blockchain-voting-API.git
  cd blockchain-voting-API

3) ESTRUTURA DO REPOSITÓRIO
---------------------------
blockchain-voting-API/
  chaincode/
    vote/            (chaincode em Go; contém um método Ping -> "pong")
  scripts/           (bootstrap / up / deploy / down)
  Makefile           (atalhos)
  env.sh             (gerado no bootstrap; exporta PATH e FABRIC_CFG_PATH)
  _deps/             (IGNORADO no git; onde ficam binários e fabric-samples)

Observação importante:
  A pasta _deps/ NÃO é comitada. Ela é recriada pelos scripts (make bootstrap).

4) PRIMEIRA EXECUÇÃO (PASSO A PASSO)
------------------------------------
Na raiz do repositório:
  make bootstrap     # baixa binários e fabric-samples para ./_deps/ e cria env.sh
  source env.sh      # habilita 'peer' no PATH e configura FABRIC_CFG_PATH para esta sessão
  make up            # sobe a test-network e cria o canal (mychannel)
  make deploy        # vendoriza dependências e faz o deploy do chaincode (./chaincode/vote)

Teste rápido (esperado: pong):
  cd _deps/fabric-samples/test-network
  source scripts/envVar.sh
  setGlobals 1
  peer chaincode query -C mychannel -n vote -c '{"Args":["Ping"]}'

Encerrar a rede:
  cd ~/dev/blockchain-voting-API   (ou a raiz do repositório)
  make down

5) ROTINA DE DESENVOLVIMENTO DO CHAINCODE
-----------------------------------------
- Edite o código em chaincode/vote (o go.mod está em go 1.20 para compatibilidade).
- Rode make deploy para publicar uma nova "sequence" do chaincode no canal.
- Use o binário peer para fazer query/invoke (depois de source env.sh + setGlobals).

6) ATALHOS DO MAKEFILE
----------------------
- make bootstrap : baixa deps e cria env.sh
- make up        : sobe a rede e cria o canal
- make deploy    : vendoriza, empacota e faz deploy do chaincode vote (Go)
- make down      : derruba a rede
- make clean     : remove _deps/, env.sh e artefatos gerados

7) TROUBLESHOOTING RÁPIDO
-------------------------
peer: command not found
  -> rode "source env.sh" na raiz do repositório. Confirme com "which peer".

Permissão do Docker
  -> garanta que o daemon está ativo e que seu usuário está no grupo docker:
     sudo systemctl enable --now docker
     sudo usermod -aG docker $USER
     newgrp docker
     docker ps

Timeout instalando chaincode
  -> já definido no deploy: CORE_PEER_CLIENT_CONNTIMEOUT=120s (ajustável no scripts/deploy-go.sh).
  -> em VMs apertadas, reiniciar os peers ajuda: docker restart peer0.org1.example.com peer0.org2.example.com

Ambiente sujo / reset
  -> make down && make up
  -> para zerar tudo: make clean && make bootstrap

8) VERSIONAMENTO
----------------
- A pasta _deps/ NÃO vai para o commit (está no .gitignore).
- Se algo pesado entrar por engano no índice, remova do staging:
    git rm -r --cached _deps env.sh
    git status --short

NOTAS FINAIS
------------
- O chaincode de exemplo expõe Ping() retornando "pong" para validar o ambiente.
- Para renomear o chaincode ou trocar linguagem/caminho, ajuste flags -ccn / -ccp no scripts/deploy-go.sh.
- Em redes lentas, definir GOPROXY=https://proxy.golang.org,direct nos peers acelera o build do chaincode.
