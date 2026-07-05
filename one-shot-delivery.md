# 一步到位 · 完成定义

**未完成本清单 = 交付未结束**；禁止把下列项留到「第二阶段」。

## 完成判断

「一步到位」不是一次性写很多文件，而是让甲方能按 README 启动、登录、看到菜单、执行 P0 流程、验证权限，并能从架构、功能、数据库、API、SQL 文档追溯实现。只要链路中任何一环缺失，都还处于实现中。

交付前按这个顺序关门：

1. requirement-map 的每个 P0 功能都能在界面入口触发
2. 每个入口都有真实 API、真实表、真实权限字和菜单/按钮配置
3. 每个写路径都有参数校验、事务边界、越权校验、必要锁/唯一约束
4. README、架构、功能、数据库 schema/设计、API、SQL、配置、变更日志已写入项目文件
5. 至少跑过本栈最低验证；无法运行时有明确环境原因和替代检查
6. 本轮没有越出 requirement-map、基座 verified 落点和用户指定范围

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
- [ ] `README.md` 含：项目介绍、技术栈、目录结构、安装依赖、导入 SQL、启动命令、默认账号、部署说明、常见问题
- [ ] Agent 执行过的验证命令及结果（compile / check / build）
- [ ] 若复制基座为新项目，说明复制来源 base-id 与本次新增模块位置

### 5. 文档（AI_RULE §23–24）

- [ ] AI 边界说明已落到本次交付摘要：本轮范围、未覆盖范围、未改核心域
- [ ] `CONTRIBUTING.md` 存在或 README 含协作规则：分支、提交、PR、文档同步
- [ ] `SECURITY.md` 存在或 README 含安全策略：支持版本、漏洞报告、密钥处理
- [ ] `CHANGELOG.md` 存在或 `AI_CHANGELOG.md` 同步用户可见变更；安全修复进 Security 分组
- [ ] `doc/ARCHITECTURE.md` 更新：基座、模块边界、调用链、权限模型、缓存/异步/外部依赖
- [ ] `doc/FUNCTIONS.md` 更新：功能清单、角色、菜单、页面、业务流程、验收用例
- [ ] `doc/DATABASE_SCHEMA.md` 更新：表、字段、类型、索引、枚举、菜单/权限数据
- [ ] `doc/DATABASE_DESIGN.md` 更新：ER 关系、状态机、唯一约束、索引设计、归属/租户字段、缓存映射
- [ ] `AI_CHANGELOG.md` 新增一条（含文件列表、是否动库、自测结果）
- [ ] `AI_API.md` 更新接口清单
- [ ] `AI_PROJECT.md` 更新模块位置、启动方式、关键目录、基座来源
- [ ] 触发表结构 → `AI_DATABASE.md` + sql 文件
- [ ] `doc/requirement-map.md` 或交付摘要含假设、out of scope、验收对照

### 5.1 代码/数据库变更文档同步矩阵

| 变更类型 | 必须同步 |
|----------|----------|
| 新增/调整功能 | `doc/FUNCTIONS.md`、`README.md` 功能入口、`AI_CHANGELOG.md`、必要时 `CHANGELOG.md` |
| 新增/调整后端接口 | `AI_API.md`、`doc/FUNCTIONS.md`、`AI_CHANGELOG.md` |
| 新增/调整前端页面/菜单 | `doc/FUNCTIONS.md`、`README.md` 验收入口、菜单/权限 SQL、`AI_CHANGELOG.md` |
| 新增/调整表字段/索引/枚举 | `sql/YYYY-MM-DD.sql`、`doc/DATABASE_SCHEMA.md`、`doc/DATABASE_DESIGN.md`、`AI_DATABASE.md`、`AI_CHANGELOG.md` |
| 数据迁移/初始化数据 | `sql/YYYY-MM-DD.sql`、`doc/DATABASE_SCHEMA.md`、README 导入步骤、回滚/幂等说明 |
| 权限/角色/租户边界 | `doc/ARCHITECTURE.md`、`doc/FUNCTIONS.md`、菜单/权限 SQL、`AI_CHANGELOG.md` |
| 缓存/Redis/锁/MQ/定时任务 | `doc/ARCHITECTURE.md`、`AI_DATABASE.md` 缓存映射、`doc/DATABASE_DESIGN.md` 幂等/状态说明 |
| 配置/环境变量/部署 | `README.md`、`.env.example`、`AI_PROJECT.md`、`AI_CHANGELOG.md` |
| 依赖/构建/脚本 | `README.md`、`AI_PROJECT.md`、`CHANGELOG.md`（用户可见时）、验证命令记录 |
| 安全修复/风险控制 | `SECURITY.md`（策略变化时）、`AI_CHANGELOG.md`、`CHANGELOG.md` 的 Security 分组、code-security 报告 |
| Breaking change | `README.md`、`CHANGELOG.md`、`AI_API.md`/`AI_DATABASE.md`、迁移与回滚说明 |

### 6. 安全（E–G 内建，K 复核）

对照 [cross-cutting-constraints.md](cross-cutting-constraints.md)：

**必查**

- [ ] §2.1 越权：会话取用户；列表带当前用户；按 ID load + 归属比对
- [ ] §3 Redis：锁 A/B/C/D + TTL（D 最长按需 7d）；锁/缓存 key 分开；改库写穿缓存

**仅需求有并发峰值 / 长时异步时**

- [ ] §4 MQ 或 DB Job + 调度；消费幂等（见 code-security）

深度审计：[checklist-core](../code-security-skill/checklist-core.md)

## 禁止作为「已完成」的情况

- ❌ 「后端好了，前端下次做」
- ❌ 「菜单你去后台手动加」
- ❌ 「SQL 你自行执行」而不给出文件
- ❌ 只给代码，不给 README/架构/功能/数据库文档
- ❌ 数据库设计文档与实际 SQL 字段、索引不一致
- ❌ 改了接口/表/配置/权限，却没同步对应文档
- ❌ 超出 requirement-map 增加功能或重构基座核心
- ❌ 真实密钥、生产账号、Token 写入 README/SQL/配置示例
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

## 文档
- README.md
- CONTRIBUTING.md / SECURITY.md / CHANGELOG.md
- doc/ARCHITECTURE.md
- doc/FUNCTIONS.md
- doc/DATABASE_SCHEMA.md
- doc/DATABASE_DESIGN.md
- AI_API.md / AI_DATABASE.md / AI_PROJECT.md / AI_CHANGELOG.md

## 验收对照
- F01 ✅ ...
- F02 ✅ ...

## 假设与未覆盖
- ...
```
