# dingtalk-contacts

钉钉通讯录技能（Skill），用于查询组织架构、部门和成员信息。  
适用于 OpenClaw / Codex 等场景，配置方式极简：只需要在技能目录放一个 `mcporter.json`。

如何获得mcp配置文件
打开下面的网址，点击右侧的【获取mcp server配置】
复制整个JSON Config，并保存成一个jons文件，命名为mcporter.json，放到技能目录下。
https://mcp.dingtalk.com/#/detail?instanceId=35840&detailType=instanceMcpDetail

## 帮助与支持
https://forreststudio.feishu.cn/drive/folder/Ma3Rf6gOclsxDQdpR7Aci8aCnbc
## 功能

- 查询部门（按关键词）
- 查询部门成员
- 按关键词查人
- 按手机号查人
- 获取当前用户组织信息

## 快速开始

1. 准备配置文件  
将你的 MCP 配置保存为仓库根目录 `mcporter.json`。

已经提供 `mcporter.example.json`，供参考：


## 配置文件示例

文件路径：`./mcporter.json`

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




## 仓库结构

```text
.
├── SKILL.md
├── README.md
├── mcporter.example.json
├── references
│   ├── configuration.md
│   └── tool-discovery.md
└── scripts
    ├── resolve_server.sh
    ├── preflight.sh
    └── discover_tools.sh
```


## 相关技能仓库

- dingtalk-contacts: https://github.com/Forrest418/dingtalk-contacts
- dingtalk-teambition: https://github.com/Forrest418/dingtalk-teambition
- dingtalk-chatgroup: https://github.com/Forrest418/dingtalk-chatgroup
- dingtalk-calendar: https://github.com/Forrest418/dingtalk-calendar
- dingtalk-attendance: https://github.com/Forrest418/dingtalk-attendance
- dingtalk-videomeeting: https://github.com/Forrest418/dingtalk-videomeeting
- dingtalk-amap: https://github.com/Forrest418/dingtalk-amap
