#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

secret="${1:-secret}"; shift
listener="demo-listener"
namespace="demo-tekton-cicd"
cluster="apps.paas.lab.stocky37.dev"
url="https://${listener}-${namespace}.${cluster}"
webhook_file="$SCRIPT_DIR/webhook.json"
body="$(cat "$webhook_file")"
sig=$(echo -n "$body" | openssl sha1 -binary -hmac "$secret" | xxd -p)
event="push"

curl -k -X POST \
  -H "X-Hub-Signature: sha1=$sig" \
  -H "X-GitHub-Event: $event" \
  -H "Content-Type: application/json" \
  --data-binary "@$webhook_file" \
  "$url"