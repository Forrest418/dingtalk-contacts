# Tool Discovery

## Goal

Select the correct MCP tool names at runtime for `dingtalk-contacts`.

## Commands

List all tool schemas:

```bash
mcporter list dingtalk-contacts --schema --json | jq '.'
```

Quick grep-like filter by tool id/name/description:

```bash
mcporter list dingtalk-contacts --schema --json \
| jq -r '.. | objects | select(has("name") or has("id")) | [.id // .name, .description // ""] | @tsv' \
| rg -i "user|employee|contact|phone|mobile|staff|dept|department|org"
```

## Mapping Heuristics

- Person fuzzy search: names containing `search` + (`user`|`employee`|`contact`)
- Exact identity lookup: names containing (`mobile`|`phone`|`staff`|`userid`)
- Org traversal: names containing (`dept`|`department`|`org`)
- Roster pull: names containing (`member`|`list_users`|`dept_users`)

## Safety

Before using tools with `create`/`update`/`delete` in name:

1. Ask user confirmation.
2. Echo target object (dept/user) before execution.
3. Prefer dry-run/read equivalent if available.
