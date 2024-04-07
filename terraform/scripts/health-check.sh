#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]
    then
        echo ERROR: Illegal number of parametres
        exit 1
fi

HEALTH_CHECK_PATH=$1
API_BASE_URL="https://python-fear-greed-api-3i2mtbjusq-ew.a.run.app"

health_check(){
    result=$(curl --location --request GET "${API_BASE_URL}/$1" \
    --header 'Content-Type: application/json' \
    -w "\nhttp_code:%{http_code}")
    echo "${result}"
    http_code=$(echo "${result}" | grep 'http_code:' | sed 's/http_code://g')
    echo "${http_code}"
}

main(){
    echo "Running health check against path $HEALTH_CHECK_PATH"
    health_check $HEALTH_CHECK_PATH
}

main "$@"