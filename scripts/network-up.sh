#!/usr/bin/env bash
set -euo pipefail
[ -f ./env.sh ] && source ./env.sh
pushd _deps/fabric-samples/test-network >/dev/null
./network.sh up createChannel
popd >/dev/null
echo "✔ Rede UP e canal criado (mychannel)."
