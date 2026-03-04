#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONFIG_PATH="${SKILL_DIR}/mcporter.json"
SERVER="$("${SCRIPT_DIR}/resolve_server.sh" "${1:-}")"

SCHEMA_JSON="$(mcporter --config "${CONFIG_PATH}" list "$SERVER" --schema --json)"

echo "${SCHEMA_JSON}" | jq -e '.status == "ok" and (.tools | type == "array")' >/dev/null

echo "${SCHEMA_JSON}" \
| jq -r '.. | objects | select(has("name") or has("id")) | [.id // .name, .description // ""] | @tsv' \
| rg -i "user|employee|contact|phone|mobile|staff|dept|department|org" || true
