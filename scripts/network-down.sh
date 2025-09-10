#!/usr/bin/env bash
set -euo pipefail
[ -f ./env.sh ] && source ./env.sh
pushd _deps/fabric-samples/test-network >/dev/null
./network.sh down
popd >/dev/null
echo "✔ Rede DOWN."
