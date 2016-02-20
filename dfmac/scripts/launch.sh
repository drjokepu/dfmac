#!/bin/bash
set -e
DFMAC_LAUNCHER_SCRIPT_NAME=${DFMAC_LAUNCHER_SCRIPT_NAME:-"df"}
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${BASE_DIR}/df_osx"
env -i ./${DFMAC_LAUNCHER_SCRIPT_NAME}
