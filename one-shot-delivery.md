# 一步到位 · 完成定义

**未完成本清单 = 交付未结束**；禁止把下列项留到「第二阶段」。

## 完成判断

「一步到位」不是一次性写很多文件，而是让甲方能按说明启动、登录、看到菜单、执行 P0 流程、验证权限、追溯 SQL 和接口。只要链路中任何一环缺失，都还处于实现中。

交付前按这个顺序关门：

1. requirement-map 的每个 P0 功能都能在界面入口触发
2. 每个入口都有真实 API、真实表、真实权限字和菜单/按钮配置
3. 每个写路径都有参数校验、事务边界、越权校验、必要锁/唯一约束
4. 新增配置、SQL、接口、表结构、变更日志已写入项目文件
5. 至少跑过本栈最低验证；无法运行时有明确环境原因和替代检查

## 必交付项

### 1. 后端

- [ ] 需求清单中 **每个 P0 功能** 有对应 API 且可编译
- [ ] Service 层事务正确；无 Controller 直写复杂 SQL
- [ ] 参数校验完整（基座 Validator / Bean Validation / Pydantic）
- [ ] 权限注解或等价中间件已挂接 **每个** 写接口
- [ ] 统一返回格式；错误不泄露栈
- [ ] 涉及状态变更的有状态机或等价校验

### 2. 数据库

- [ ] `sql/YYYY-MM-DD.sql` 含建表、索引、**菜单/权限**（若基座用 SQL 导菜单）
- [ ] 字段注释、必要唯一索引（防重复提交）
- [ ] `AI_DATABASE.md` 或项目等价文档已更新

### 3. 前端

- [ ] 每个 P0 功能有列表页；增删改查入口完整（需求要删才做删）
- [ ] 路由注册 + **侧栏菜单** 可见（非仅隐藏路由）
- [ ] API 模块封装；非页面内硬编码 URL
- [ ] 按钮级权限与后端 perms 一致
- [ ] 表单校验与后端对齐
- [ ] 空态、加载态、错误提示沿用基座组件

### 4. 配置与运行

- [ ] `.env.example` / `application-*.yml.example` 列出新增配置项
- [ ] README 或 AI_PROJECT.md 含：**安装依赖 → 导入 SQL → 启动命令**
- [ ] Agent 执行过的验证命令及结果（compile / check / build）
- [ ] 若复制基座为新项目，说明复制来源 base-id 与本次新增模块位置

### 5. 文档（AI_RULE §23–24）

- [ ] `AI_CHANGELOG.md` 新增一条（含文件列表、是否动库、自测结果）
- [ ] `AI_API.md` 更新接口清单
- [ ] 触发表结构 → `AI_DATABASE.md` + sql 文件
- [ ] `doc/requirement-map.md` 或交付摘要含假设、out of scope、验收对照

### 6. 安全（E–G 内建，K 复核）

对照 [cross-cutting-constraints.md](cross-cutting-constraints.md)：

**必查**

- [ ] §2.1 越权：会话取用户；列表带当前用户；按 ID load + 归属比对
- [ ] §3 Redis：锁 A/B/C/D + TTL（D 最长按需 7d）；锁/缓存 key 分开；改库写穿缓存

**仅需求有并发峰值 / 长时异步时**

- [ ] §4 MQ 或 DB Job + 调度；消费幂等（见 code-security）

对照：[reference-java-monolith-redis.md](distill/reference-java-monolith-redis.md)

## 禁止作为「已完成」的情况

- ❌ 「后端好了，前端下次做」
- ❌ 「菜单你去后台手动加」
- ❌ 「SQL 你自行执行」而不给出文件
- ❌ 仅 Mock 数据无真实 API
- ❌ 改动了基座 `system`/`framework`/`core` 且无升级需求依据
- ❌ 未读 `references/bases/{base-id}/` 就凭记忆写路径
- ❌ 留 `# TODO` 在 P0 路径
- ❌ 只在交付摘要里写菜单权限，项目内没有 SQL/种子/配置落点
- ❌ 缓存绕过权限范围，或锁 TTL 与 A/B/C/D 场景不匹配

## 自测最低标准

| 栈 | 命令 |
|----|------|
| Java | `mvn test-compile` 或模块 compile |
| Python | `manage.py check` |
| Go | `go build ./...` |
| .NET | `dotnet build` |
| PHP | `php artisan route:list`（Laravel） |

可选：启动后 curl 登录 + 调一条新 API（环境允许时 **必须尝试**）。

## 交付说明模板（回复用户）

```markdown
## 交付摘要
- 基座：{base-id}
- 模块：{biz}

## 变更文件
- ...

## 使用步骤
1. 导入 sql/YYYY-MM-DD.sql
2. 启动后端：...
3. 启动前端：...
4. 默认账号：...（基座文档）

## 验收对照
- F01 ✅ ...
- F02 ✅ ...

## 假设与未覆盖
- ...
```
