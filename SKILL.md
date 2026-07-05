---
name: ai-code-standard-project
description: >-
  Build one-shot business systems on verified open-source admin bases such as
  RuoYi, django-vue-admin, YiSha, yi-netcore, gfast, yjgo, or b5-laravel. Use
  when the user provides requirements for a new project/module, asks to generate
  a complete admin system, or wants "一步到位" delivery. If language/base is not
  specified, ask with base-selection-prompt before coding. Always read
  references/bases/{base-id} and distill/verified-{base-id}.md, add business
  modules only, keep the base structure intact, and complete code, SQL, menus,
  permissions, docs, validation, authorization, and Redis/concurrency checks in
  one pass.
---

# AI 标准 · 新项目一步到位开发

在**有名开源管理后台**上接甲方需求：**以 `references/bases/` 源码为准**，**只增业务、不大改框架**，**单次交付闭环**。

## 三条契约

本 skill 是「在已验证基座上做业务交付」的执行规约，不是脚手架重写器。每次触发都要同时守住三件事：

1. **范围契约**：先把需求变成 requirement-map；没有映射到表、接口、页面、权限、验收的 P0 功能，视为尚未读完需求
2. **基座契约**：以 `references/bases/{base-id}/` 真实源码和 `distill/verified-{base-id}.md` 为权威；路径、权限、返回、分页、菜单都跟随基座
3. **交付契约**：本轮完成后端、前端、SQL、菜单、配置、README、架构/功能/数据库/API 文档、自测、安全复核；不能把 P0 项拆给「下一步」

## AI 边界规则

AI 只能在需求、requirement-map、选定基座和本轮明确任务边界内工作。成熟 GitHub 项目的做法是把 README、贡献规则、安全策略、变更记录、扫描结果都当作项目契约；本 skill 也按这个口径执行。

### 禁止越界

- **禁止擅自扩需求**：未进入 requirement-map 的 P0/P1 功能不实现；发现必要依赖时先写假设或问用户
- **禁止改基座核心**：不改 `system` / `framework` / `core` / 认证 / 全局异常 / 全局返回，除非需求明确要求且文档说明影响
- **禁止跨模块重构**：不因局部业务生成而重命名包、迁移目录、替换 ORM/权限/缓存/前端框架
- **禁止破坏兼容**：改接口、字段、枚举、权限字、菜单路径、配置 key 时，必须同步文档并标注 breaking/change
- **禁止静默删数据**：DDL/DML 必须可追溯；删除字段/表/索引/菜单/权限要有迁移说明、备份/回滚或明确不可逆
- **禁止静默升级依赖**：仅为本需求所需才升级；同步 README/AI_PROJECT/CHANGELOG，说明兼容性和验证结果
- **禁止写真实密钥**：README、SQL、配置示例、测试数据只写占位符；安全报告或 SECURITY 说明漏洞报告方式
- **禁止只改代码不改文档**：代码、数据库、接口、配置、权限、部署、依赖任一变化，都要走下方文档同步矩阵

### 必须留证据

- 每次交付说明本轮范围、未覆盖范围、读过的基座 Demo/verified 文档、验证命令
- 每个变更在 `AI_CHANGELOG.md` 有记录；用户可见变化进入 `CHANGELOG.md` 或 README 相关章节
- 安全相关变化进入 `SECURITY.md` / `AI_CHANGELOG.md` 的 `Security` 项；必要时运行 code-security 审查

## 规范优先级

| 优先级 | 来源 | 用途 |
|--------|------|------|
| 1 | [references/bases/README.md](references/bases/README.md) + `distill/verified-*.md` | **基座结构、Demo、禁止改范围** |
| 2 | [cross-cutting-constraints.md](cross-cutting-constraints.md) | **越权 + Redis**；MQ 仅并发/async |
| 3 | [../ai-code-standard/AI_RULE.md](../ai-code-standard/AI_RULE.md) | 编码、事务、缓存、文档联动 |
| 4 | [../code-security-skill/](../code-security-skill/) | 资损/越权/并发深度审计（交付前 Step K） |
| 5 | [../xf-app-assistant/SKILL.md](../xf-app-assistant/SKILL.md) | Java 单体模块边界原文（映射 §1 表） |

## 何时触发

- 用户提供**需求文档**要新建/交付完整功能
- 指定或隐含技术栈（Java / .NET / Python / Go / PHP）
- 有开源基座源码 **或** 需从 [base-catalog.md](base-catalog.md) 拉取基座
- 明确要求「一步到位」「不要分阶段」

**不触发**：存量小补丁、纯安全审计、纯架构咨询（用对应专项 skill）。

## 执行原则

1. **基座源码优先**：Step B 必读 `references/bases/{base-id}/` + `verified-*.md`，对照 Demo 再写码
2. **不推翻基座**：不改框架分层、不迁库、不换认证、不改全局返回；**禁止重构 system/framework/core**
3. **你提需求我搭项目**：复制基座到目标目录（或甲方已有同基座仓）→ 新建业务模块/页面/SQL 菜单
4. **一步到位**：单次会话交付 [one-shot-delivery.md](one-shot-delivery.md) 全部必选项
5. **先分析后写码**：按 AI_RULE 第二条走完再动手
6. **公共能力复用**：HTTP/Redis/锁/上传/权限/分页 — 用基座已有能力
7. **越权 + Redis 必做**；**MQ 仅并发/async 需求**（cross-cutting §4）
8. **业务增量隔离**：新增代码优先放 `biz`/独立 module/Area/app 包；只在注册点接入路由、菜单、依赖和配置

## 一步到位主流程

复制跟踪（**全部完成才结束**）：

```
[ ] A.  intake — 解析需求文档 → requirement-map.md（本仓库临时或项目 doc/）
[ ] B.  base — **未指定则 AskQuestion 选型** → 读 references/bases/{id}
[ ] C.  plan — 越权 + Redis 锁/TTL；**有并发/async 才**规划 MQ 或 DB Job
[ ] D.  data — sql/ + 索引 + 防重复 UNIQUE（§3.1 D 类锁须配）
[ ] E.  backend — verified 落点 + §5 权限 + §2.1 越权 + §3 Redis
[ ] F.  frontend — 页面/API + 权限指令 + 分页
[ ] G.  auth — 菜单/perms **本轮完成**
[ ] H.  config — .env.example 增量
[ ] I.  docs — README + 架构/功能/数据库/API/变更文档（见 one-shot-delivery）
[ ] J.  verify — one-shot-delivery 自检
[ ] K.  security — cross-cutting §2.1 + §3；有 MQ 再 §4
```

**禁止**向用户说「下一步再做了菜单/权限/前端」——未完成的项在本轮继续做完。

### 工作节奏

- **先问少量阻塞问题**：只问语言/基座、项目路径、关键业务歧义；能从需求和基座推断的写入假设
- **边读边落文档**：requirement-map、README、架构、数据库、功能、API、SQL、CHANGELOG 不等最后补；它们是实现过程的追溯证据
- **小步实现但大闭环交付**：可以按模块逐个完成，但每个 P0 功能都要穿透 DB → API → UI → 权限 → 验收
- **发现基座冲突时停写路径**：先以真实源码修正 stack-guides/requirement-map 中的落点，再继续开发

## Step A：需求解析

读用户需求文档，输出结构化 **requirement-map**（模板见 [requirement-parsing.md](requirement-parsing.md)）：

- 功能列表（CRUD / 审批 / 报表 / 导入导出 / 第三方）
- 角色与权限
- 实体与字段、状态机、是否并发写（积分/订单）
- 非功能：性能、工作流、多租户、移动端

**缺失且阻塞**：用 AskQuestion 问清；**未指定语言/基座时必走** [base-selection-prompt.md](base-selection-prompt.md)，等用户选完再进入 C。

### Step B：基座选择（**未指定则先让用户选**）

**用户未说清语言或基座** → **必须**：

1. 展示 [base-selection-prompt.md](base-selection-prompt.md) 选项表（语言 + base-id + 一句话架构）
2. 有 AskQuestion 工具时用 **AskQuestion** 让用户选；没有该工具时用一条简短问题等待用户回复，如 `Java · ruoyi-cloud`
3. 选定后写入 requirement-map 的 `base-id`，**此步完成前禁止写业务代码**

**用户已指定**（如「用 ruoyi-cloud」）→ 复述「语言 + base-id + 一句话架构」请用户确认即可。

**确认后**（无论问卷或指定）：

1. 读 [references/bases/README.md](references/bases/README.md) + `distill/verified-{base-id}.md`
2. 在 **`references/bases/{base-id}/`** 打开「对照 Demo」或 grep 同类代码
3. **无甲方项目目录**：复制基座到目标路径；勿在 skill 的 `references/bases/` 里当交付仓大改
4. 本地无克隆：`bash scripts/sync-bases.sh {base-id}`

**禁止**未确认 base-id 就写路径（例：`ruoyi` **没有** `ruoyi-ui`）。

完整选项与 AskQuestion 配置 → [base-selection-prompt.md](base-selection-prompt.md)  
URL / commit → [base-catalog.md](base-catalog.md) + `references/manifest.json`

## Step C–G：按栈实施

打开 [stack-guides.md](stack-guides.md) + **基座 Demo**，**严格按 verified 落点**写代码：

- Java RuoYi **Thymeleaf**（`ruoyi`）→ `ruoyi-admin` 包 + `templates/`；`@RequiresPermissions`
- Java **Vue 分离**（`ruoyi-cloud` / `ruoyi-activiti`）→ `ruoyi-modules/ruoyi-{biz}` + `ruoyi-ui`；`@PreAuthorize`
- Java React → `react-ui/src/pages/`
- .NET MVC → `yisha` Area；ABP → `yi-netcore` module
- Python / Go / PHP → 见 stack-guides 各节

**禁止**改 `ruoyi-system`、`dvadmin/system`、`internal/app/system` 等核心域。

**代码生成**：若基座带 generator（RuoYi/gfast 等），优先生成再手改，避免手写重复 CRUD。

## Step H–I：项目文档（强制）

按 [../ai-code-standard/AI_RULE.md](../ai-code-standard/AI_RULE.md) §23–24：

| 文件 | 何时写 |
|------|--------|
| `README.md` | 新项目必写；含项目介绍、技术栈、目录结构、启动、账号、部署、常见问题 |
| `CONTRIBUTING.md` | 新项目必建；存量项目已有则只补文档同步/边界规则 |
| `SECURITY.md` | 新项目必建；含支持版本、漏洞报告方式、敏感信息处理 |
| `CHANGELOG.md` | 新项目必建；面向用户/版本，按 Added/Changed/Fixed/Security/Breaking 分组 |
| `doc/ARCHITECTURE.md` | 新项目必写；含基座说明、模块边界、调用链、权限模型、缓存/异步/外部依赖 |
| `doc/FUNCTIONS.md` | 新项目必写；含功能清单、角色、菜单、页面、业务流程、验收用例 |
| `doc/DATABASE_SCHEMA.md` | 新项目必写；从最终 SQL 同步表、字段、类型、索引、枚举、菜单/权限表变更 |
| `doc/DATABASE_DESIGN.md` | 新项目必写；说明 ER 关系、状态机、唯一约束、索引设计、归属/租户字段、缓存映射 |
| `AI_CHANGELOG.md` | 每次交付必追加一条 |
| `sql/YYYY-MM-DD.sql` | 任何 DDL |
| `AI_API.md` | 新增/改接口 |
| `AI_DATABASE.md` | 表/索引/缓存映射 |
| `AI_PROJECT.md` | 模块位置、启动方式 |
| `doc/requirement-map.md` | 需求追溯（推荐） |

**初始化建议**：复制或生成基座到目标项目后，先运行 `bash scripts/init-project-docs.sh /path/to/project 项目名` 建好文档骨架，再随实现同步填充。若目标项目已有同名文档，只追加/修订本次相关章节，禁止覆盖历史。

**文档必须与代码一致**：

- 数据库 schema 以最终 `sql/YYYY-MM-DD.sql` 和迁移文件为准
- 架构文档以真实目录、模块依赖、路由/网关/菜单接入点为准
- 功能文档以 requirement-map 的 P0 功能和实际页面/API 为准
- README 面向接手项目的人，必须能按步骤启动和验收

完整完成定义与「代码/数据库变更文档同步矩阵」见 [one-shot-delivery.md](one-shot-delivery.md)。

## Step J–K：验证与安全

**最小验证**（按栈执行存在的命令）：

```bash
# Java
mvn -q -pl ruoyi-xxx test-compile || mvn -q test-compile

# Python
python manage.py check

# Go
go build ./...

# .NET
dotnet build
```

**安全增量（Step K）**：[cross-cutting-constraints.md §2](cross-cutting-constraints.md) + [architecture-patterns §2](../code-security-skill/architecture-patterns.md) + [checklist-core](../code-security-skill/checklist-core.md)

验证失败时不要直接交付。先修复本次引入的问题；若失败来自基座历史问题或环境缺失，在交付摘要中写清命令、失败点、影响范围和已完成的替代检查。

## Java 单体与 xf-app-assistant

已泛化到 [cross-cutting-constraints.md §1](cross-cutting-constraints.md) 全栈表。Java 细节仍可读 `@xf-app-assistant`，映射为 `ruoyi-{biz}` / 独立 Maven module，**禁止**改 `ruoyi-system` 核心域。

## 交付物清单

用户应拿到（见 [one-shot-delivery.md](one-shot-delivery.md)）：

- 可编译/可启动的增量代码
- SQL 与菜单/权限数据（或 SQL 脚本）
- 前端页面与路由
- 环境配置说明
- README + 架构文档 + 功能文档 + 数据库 schema/设计文档
- CHANGELOG + API + 项目说明文档
- 简短「如何启动验证」说明

## 附加资源

| 文件 | 内容 |
|------|------|
| [cross-cutting-constraints.md](cross-cutting-constraints.md) | **边界/安全/性能融合（全栈，开发内建）** |
| [base-selection-prompt.md](base-selection-prompt.md) | **Step B：语言/基座选项表 + AskQuestion** |
| [references/bases/README.md](references/bases/README.md) | 11 基座源码索引、Demo、禁止大改 |
| [distill/README.md](distill/README.md) | 克隆蒸馏索引 |
| [base-catalog.md](base-catalog.md) | URL、同步状态、选型修正 |
| [stack-guides.md](stack-guides.md) | 各语言落点、分层、权限、代码生成 |
| [requirement-parsing.md](requirement-parsing.md) | 需求文档 → 实施清单 |
| [one-shot-delivery.md](one-shot-delivery.md) | 一步到位的完成定义 |
| [examples.md](examples.md) | 对话示例 |
| [scripts/sync-bases.sh](scripts/sync-bases.sh) | 拉取/更新基座参考源码 |
