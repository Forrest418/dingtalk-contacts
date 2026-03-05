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
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONFIG_PATH="$(${SCRIPT_DIR}/mcp.sh --print-config-path 2>/dev/null || true)"

if [[ -z "${CONFIG_PATH}" || ! -f "${CONFIG_PATH}" ]]; then
  echo "[resolve] 缺少配置文件。" >&2
  echo "[resolve] 查找顺序: ${OPENCLAW_HOME:-$HOME/.openclaw}/config/mcporter.json -> ${OPENCLAW_HOME:-$HOME/.openclaw}/workspace/config/mcporter.json -> ${SKILL_DIR}/mcporter.json" >&2
  exit 1
fi

mcp() {
  "${SCRIPT_DIR}/mcp.sh" "$@"
}

# Priority:
# 1) first arg
# 2) common names: 钉钉通讯录 / dingtalk-contacts
# 3) auto-detect by required tool names

is_server_ok() {
  local name="$1"
  local output
  output="$(mcp list "${name}" --schema --json 2>/dev/null || true)"
  echo "${output}" | jq -e '.status == "ok"' >/dev/null 2>&1
}

if [[ "${1:-}" != "" ]]; then
  if is_server_ok "$1"; then
    echo "$1"
    exit 0
  fi
  echo "[resolve] 指定服务不可用: $1" >&2
  exit 1
fi

for name in "钉钉通讯录" "dingtalk-contacts"; do
  if is_server_ok "${name}"; then
    echo "${name}"
    exit 0
  fi
done

AUTO_NAME="$({
  mcp list --json 2>/dev/null \
  | jq -r '
      .servers[]
      | select(.status == "ok")
      | select(
          (any(.tools[]?; .name == "search_dept_by_keyword"))
          and
          (any(.tools[]?; .name == "search_user_by_mobile"))
        )
      | .name
    ' \
  | head -n 1
} || true)"

if [[ "${AUTO_NAME}" != "" ]]; then
  echo "${AUTO_NAME}"
  exit 0
fi

echo "[resolve] 未找到可用的钉钉通讯录 MCP 服务。" >&2
echo "[resolve] 请检查主配置目录或技能目录中的 mcporter.json 的 mcpServers 配置。" >&2
exit 1
