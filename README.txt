PROJETO: blockchain-voting-API
ASSUNTO: Como instalar os requisitos, baixar o projeto e rodar localmente

============================================================
1) PRÉ-REQUISITOS (OBRIGATÓRIO)
============================================================
- Node.js 18 ou superior (recomendado 20 LTS)
- npm (vem junto com o Node)
- Git

COMO INSTALAR (Linux/WSL/Ubuntu):
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs
  node -v     # conferir versão (>= 18)
  npm -v      # conferir npm

COMO INSTALAR (Windows):
  1) Baixar Node LTS em https://nodejs.org
  2) Instalar Git em https://git-scm.com/downloads
  3) Conferir no terminal:
     node -v
     npm -v
     git --version

OPCIONAL:
- Editor de código (VS Code, etc.)

============================================================
2) CLONAR O REPOSITÓRIO
============================================================
Substitua <URL_DO_REPO> pela URL real do GitHub.

  git clone <URL_DO_REPO>
  cd blockchain-voting-API

============================================================
3) INSTALAR DEPENDÊNCIAS DO PROJETO
============================================================
  npm install

Se aparecer erro de dependências (ERESOLVE), tente:
  npm install --legacy-peer-deps

============================================================
4) COMANDOS BÁSICOS
============================================================
COMPILAR CONTRATOS:
  npx hardhat compile

RODAR TESTES:
  npx hardhat test

SUBIR NÓ LOCAL (RPC em http://127.0.0.1:8545):
  npx hardhat node

(Em outro terminal) DEPLOY LOCAL (opcional, somente se quiser interagir):
  npx hardhat ignition deploy ./ignition/modules/Counter.ts --network localhost

============================================================
5) VARIÁVEIS DE AMBIENTE (APENAS SE FOR USAR TESTNET)
============================================================
Se for fazer deploy na testnet Sepolia, crie um arquivo .env na raiz:

  SEPOLIA_URL="https://eth-sepolia.exemplo/v2/SEU_RPC"
  PRIVATE_KEY="0xSUA_CHAVE_PRIVADA_DE_TESTE"
  ETHERSCAN_API_KEY="SUA_CHAVE"   # opcional

Observações:
- .env NÃO deve ser commitado (já está no .gitignore).
- PRIVATE_KEY deve ser de uma conta de TESTE, nunca de produção.

============================================================
6) ESTRUTURA DO PROJETO (PADRÃO HARDHAT v3)
============================================================
  contracts/      -> contratos Solidity (ex.: Counter.sol)
  test/           -> testes (Mocha e/ou Solidity)
  ignition/       -> módulos de deploy (Ignition)
  hardhat.config.js  -> configuração do Hardhat (ESM)
  package.json
  README / LEIA-ME

============================================================
7) DICAS E SOLUÇÃO DE PROBLEMAS
============================================================
- Hardhat v3 é ESM: o package.json tem "type": "module".
  Evite require()/module.exports; use import/export.

- Se der erro "ERESOLVE" ao instalar:
  npm install --legacy-peer-deps

- Verifique versão do Node:
  node -v   (precisa ser >= 18)

- Para limpar e reconstruir rapidamente:
  rm -rf node_modules package-lock.json
  npm install
  npx hardhat compile
  npx hardhat test

============================================================
8) FLUXO DE USO RECOMENDADO
============================================================
1. Editar/Adicionar contratos em: contracts/
2. Rodar testes: npx hardhat test
3. (Opcional) Subir nó local: npx hardhat node
4. (Opcional) Deploy local: ver comando na seção 4
5. (Opcional) Deploy em Sepolia: configurar .env e criar script de deploy se necessário

