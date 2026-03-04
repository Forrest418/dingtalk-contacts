#!/usr/bin/env bash
set -euo pipefail
SERVER="${1:-${DINGTALK_CONTACTS_SERVER:-dingtalk-contacts}}"
mcporter list "$SERVER" --schema --json \
| jq -r '.. | objects | select(has("name") or has("id")) | [.id // .name, .description // ""] | @tsv' \
| rg -i "user|employee|contact|phone|mobile|staff|dept|department|org" || true
