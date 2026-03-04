---
name: dingtalk-contacts
description: 通用钉钉通讯录技能（组织架构、部门、成员、手机号/工号定位）。当用户提到“通讯录/组织架构/找人/按手机号查人/部门成员/负责人/员工信息”时使用。通过 mcporter 调用任意名称的 dingtalk-contacts MCP 服务，先发现工具再执行查询；用户只需维护自身 MCP 配置（服务名/URL）即可使用。
homepage: https://mcp.dingtalk.com
metadata:
  openclaw:
    emoji: "👥"
    requires:
      bins: ["mcporter", "jq"]
---

# DingTalk Contacts

Use this skill to retrieve DingTalk org and people data from a configurable MCP server.

## User-Maintained Config (Only)

Users only need to maintain:

- MCP JSON config file in skill root: `mcporter.json`
- Streamable HTTP URL (required)

See [references/configuration.md](references/configuration.md) for minimal config patterns.

At runtime, resolve server name with:

```bash
SERVER="$(scripts/resolve_server.sh)"
```

## Execution Policy

- Run locally with `exec`/shell; do not use remote node execution.
- Perform tool discovery before first query.
- Use canonical call format for stability:
  - `mcporter --config "<skill-root>/mcporter.json" call "${SERVER}.<tool>" key:value --output json`
- Prefer read-only operations; ask for confirmation before write/update actions.
- If no data is returned, treat as no-match first; then optionally broaden keyword or retry with equivalent field naming discovered from schema.

## Preflight

Use bundled script:

```bash
scripts/preflight.sh
```

## Discover Available Tools

Use bundled script:

```bash
scripts/discover_tools.sh
```

Then pick actual selector names from schema (different deployments may differ).

## Common Query Workflows

### 1) Search People By Keyword

1. Search user IDs by keyword.
2. Query details by returned user IDs.

Example pattern:

```bash
SERVER="$(scripts/resolve_server.sh)"
CONFIG_PATH="mcporter.json"
IDS=$(mcporter --config "${CONFIG_PATH}" call "${SERVER}.search_user_by_key_word" key-word:"王" --output json | jq -r '.result[]?.userId')
mcporter --config "${CONFIG_PATH}" call "${SERVER}.get_user_info_by_user_ids" user-id-list:"$IDS" --output json
```

### 2) Locate A User By Mobile / Staff ID

1. Query by mobile.
2. Return normalized fields: name, userId, dept.

Example pattern:

```bash
SERVER="$(scripts/resolve_server.sh)"
CONFIG_PATH="mcporter.json"
mcporter --config "${CONFIG_PATH}" call "${SERVER}.search_user_by_mobile" mobile:"13800000000" --output json
```

### 3) Browse Departments And Members

1. Search department by keyword.
2. List members by dept ID.

Example pattern:

```bash
SERVER="$(scripts/resolve_server.sh)"
CONFIG_PATH="mcporter.json"
mcporter --config "${CONFIG_PATH}" call "${SERVER}.search_dept_by_keyword" query:"营销" --output json
mcporter --config "${CONFIG_PATH}" call "${SERVER}.get_dept_members_by_deptId" dept-ids:"988113313" --output json
```

### 4) Build Org Snapshot (Read-Only)

1. Enumerate key departments by keywords.
2. Pull dept members for target departments.
3. Summarize as compact table.

## Output Guidelines

- Include selector/tool names used in summary for traceability.
- When fields are noisy, return a compact table: `name | staffId | dept | title`.
- Mask phone numbers unless user explicitly asks full value.
- If API returns empty `{}` or `[]`, report as no-match plus next-step suggestion.

## References

- Config setup and examples: `references/configuration.md`
- Tool discovery and selection guide: `references/tool-discovery.md`
