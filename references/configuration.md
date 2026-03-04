# Configuration

## Goal

Allow users to finish setup by placing one JSON file in the skill directory.

## Single-Step Setup

Put this file at:

- `./mcporter.json` (skill root)

```json
{
  "mcpServers": {
    "钉钉通讯录": {
      "type": "streamable-http",
      "url": "https://mcp-gw.dingtalk.com/server/<serverId>?key=<key>"
    }
  }
}
```

Notes:

- Replace `url` with your own MCP URL.
- Service name can be any value; `钉钉通讯录` is recommended.
- If you already have an existing `mcporter.json`, merge this server into `mcpServers`.

## Verify

```bash
./scripts/preflight.sh
./scripts/discover_tools.sh
```

Expected:

- Preflight prints `ok`
- Discovery prints contact/department-related tools
