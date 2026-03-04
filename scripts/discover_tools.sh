#!/usr/bin/env bash
set -euo pipefail

resolve_script_dir() {
  local src="${BASH_SOURCE[0]}"
  while [[ -h "${src}" ]]; do
    local dir
    dir="$(cd -P "$(dirname "${src}")" && pwd)"
    src="$(readlink "${src}")"
    [[ "${src}" != /* ]] && src="${dir}/${src}"
  done
  cd -P "$(dirname "${src}")" && pwd
}

SCRIPT_DIR="$(resolve_script_dir)"
SERVER="$(${SCRIPT_DIR}/resolve_server.sh "${1:-}")"

SCHEMA_JSON="$(${SCRIPT_DIR}/mcp.sh list "${SERVER}" --schema --json)"

echo "${SCHEMA_JSON}" | jq -e '.status == "ok" and (.tools | type == "array")' >/dev/null

TOOL_ROWS="$(echo "${SCHEMA_JSON}" | jq -r '.. | objects | select(has("name") or has("id")) | [.id // .name, .description // ""] | @tsv')"
PATTERN='user|employee|contact|phone|mobile|staff|dept|department|org'

if command -v rg >/dev/null 2>&1; then
  echo "${TOOL_ROWS}" | rg -i "${PATTERN}" || true
else
  echo "${TOOL_ROWS}" | grep -Ei "${PATTERN}" || true
fi
