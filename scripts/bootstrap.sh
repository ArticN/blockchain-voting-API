#!/usr/bin/env bash
set -euo pipefail
FABRIC_VERSION="${FABRIC_VERSION:-2.5.12}"

mkdir -p _deps
pushd _deps >/dev/null

# Baixa instalador oficial e traz docker+binary+samples para esta pasta
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh
chmod +x install-fabric.sh
./install-fabric.sh --fabric-version "${FABRIC_VERSION}" docker binary samples

popd >/dev/null

# Cria env.sh apontando para bin e config recém-baixados
cat > env.sh << EOT
export PATH="$(pwd)/_deps/bin:\$PATH"
export FABRIC_CFG_PATH="$(pwd)/_deps/fabric-samples/config"
EOT

echo "✔ Bootstrap concluído para Fabric ${FABRIC_VERSION}"
echo "→ Ative o ambiente:  source env.sh"
