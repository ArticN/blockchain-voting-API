#!/usr/bin/env bash
set -euo pipefail
[ -f ./env.sh ] && source ./env.sh

CC_NAME="${1:-vote}"
# caminho do chaincode a partir da pasta test-network
CC_PATH="../../../chaincode/vote"
CC_LANG="go"

pushd _deps/fabric-samples/test-network >/dev/null
export CORE_PEER_CLIENT_CONNTIMEOUT=120s
./network.sh deployCC -ccn "${CC_NAME}" -ccp "${CC_PATH}" -ccl "${CC_LANG}"
popd >/dev/null
echo "✔ Chaincode '${CC_NAME}' implantado."
