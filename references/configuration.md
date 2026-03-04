# Configuration

## Goal

Allow users to use this skill by maintaining only:

- MCP server name (optional)
- MCP server URL (required)

## Option A: One-Line Add (Recommended)

```bash
mcporter config add dingtalk-contacts --url "<STREAMABLE_HTTP_URL>"
```

If you want a custom server name:

```bash
mcporter config add "<YOUR_SERVER_NAME>" --url "<STREAMABLE_HTTP_URL>"
```

Then set:

```bash
export DINGTALK_CONTACTS_SERVER="<YOUR_SERVER_NAME>"
```

## Option B: JSON Config File

Project-level (`./config/mcporter.json`) or system-level (`~/.mcporter/mcporter.json`):

```json
{
  "mcpServers": {
    "dingtalk-contacts": {
      "baseUrl": "https://mcp-gw.dingtalk.com/server/<serverId>?key=<key>"
    }
  },
  "imports": []
}
```

If server name is not `dingtalk-contacts`, set:

```bash
export DINGTALK_CONTACTS_SERVER="<YOUR_SERVER_NAME>"
```

## Verify

```bash
SERVER="${DINGTALK_CONTACTS_SERVER:-dingtalk-contacts}"
mcporter list "${SERVER}" --schema --json | jq '.name, .status'
```

Expected:

- `.status` is `ok`
- `tools` array exists
