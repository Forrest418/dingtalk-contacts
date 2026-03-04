#!/usr/bin/env bash
set -euo pipefail

SERVER="${1:-${DINGTALK_CONTACTS_SERVER:-dingtalk-contacts}}"

if ! command -v mcporter >/dev/null 2>&1; then
  echo "[preflight] missing binary: mcporter" >&2
  exit 2
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "[preflight] missing binary: jq" >&2
  exit 2
fi

echo "[preflight] mcporter version: $(mcporter --version)"
echo "[preflight] checking server: ${SERVER}"

if ! mcporter list "${SERVER}" --schema --json >/tmp/dingtalk-contacts-schema.json 2>/tmp/dingtalk-contacts-schema.err; then
  echo "[preflight] server check failed for '${SERVER}'" >&2
  cat /tmp/dingtalk-contacts-schema.err >&2 || true
  echo "[preflight] fix: configure MCP URL and retry" >&2
  echo "[preflight] example: mcporter config add ${SERVER} --url \"<STREAMABLE_HTTP_URL>\"" >&2
  exit 1
fi

TOOL_COUNT="$(jq '.tools | length' /tmp/dingtalk-contacts-schema.json 2>/dev/null || echo 0)"
echo "[preflight] ok: server=${SERVER}, tools=${TOOL_COUNT}"
