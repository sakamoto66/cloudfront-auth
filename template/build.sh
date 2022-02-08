#!/usr/bin/env bash

npm i

ENV=${1}
if [ -z "$ENV" ]; then
    ENV=cloudfront-auth
fi
SCRIPT_DIR=$(cd $(dirname $0); pwd)
FILENAME="${SCRIPT_DIR}/.env"
SECRETS=$(aws secretsmanager get-secret-value --secret-id ${ENV}| jq -r '.SecretString')
CLIENT_ID=$(echo $SECRETS| jq -r '.CLIENT_ID')
CLIENT_SECRET=$(echo $SECRETS| jq -r '.CLIENT_SECRET')
PRIVATE_KEY=$(echo $SECRETS| jq -r '.PRIVATE_KEY')
PUBLIC_KEY=$(echo $SECRETS| jq -r '.PUBLIC_KEY')
echo "CLIENT_ID=${CLIENT_ID}" > ${FILENAME}
echo "CLIENT_SECRET=${CLIENT_SECRET}" >> ${FILENAME}
echo "PRIVATE_KEY=${PRIVATE_KEY}" >> ${FILENAME}
echo "PUBLIC_KEY=${PUBLIC_KEY}" >> ${FILENAME}

zip -q -r cloudfront-auth-lambda.zip *.js *.json .env node_modules/
