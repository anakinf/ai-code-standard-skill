# 基座参考源码（Agent 必读）

**路径**：`references/bases/{base-id}/`  
**commit**：`references/manifest.json`  
**精修落点**：`distill/verified-{base-id}.md`

本目录是 **11 套开源管理后台的完整克隆**，供 Agent **读源码学模式、对照路径、抄 Demo**，不是让你在这里直接改甲方交付物。

---

## 核心约定（用户要求）

1. **你提需求，我用基座搭项目**：选型 → 读 `verified-*.md` + 本目录同类代码 → **只加业务** → 一步到位交付。
2. **不大改框架**：禁止重构 `system` / `framework` / `core` / 认证 / 全局返回 / 启动类扫描逻辑。
3. **先读再写**：未在 `references/bases/{base-id}/` 内 grep/打开同类 Controller、菜单 SQL、前端页面前，**禁止凭记忆写路径**。
4. **skill 仓内基座保持只读**：甲方新项目应 **复制基座到新目录** 或在甲方已有仓库里 **增量模块**；勿把 skill 里的 `references/bases/` 当最终项目直接提交。

---

## 新项目搭建流程

```
需求文档
  → Step B：用户选 语言 + base-id（[base-selection-prompt.md](../../base-selection-prompt.md)）
  → 读 verified + references/bases/{id} Demo
  → 复制基座 → 只增业务 → 一步交付
```

**允许的小改动（配置级）**：根 `pom.xml` 增加 module、网关/Nacos 路由、`router` 注册、`appsettings` 连接串、`.env.example` —— **不是**改框架域逻辑。

---

## 11 基座一览

| base-id | 技术栈 | 前端 | 业务增量落点 | 禁止大改 |
|---------|--------|------|--------------|----------|
| `ruoyi` | Java Spring Boot **Thymeleaf 单体** | 服务端 HTML | `ruoyi-admin/.../controller/{biz}/` + `templates/{biz}/`；或新建 `ruoyi-{biz}` 模块 | `ruoyi-framework`、`ruoyi-system` 域 |
| `ruoyi-cloud` | Java **微服务** + Vue | `ruoyi-ui/` | `ruoyi-modules/ruoyi-{biz}` + `ruoyi-api` + 网关路由 + `ruoyi-ui/src/views/{biz}/` | `ruoyi-auth`、公共 common、网关过滤器链 |
| `ruoyi-react` | Java 单体 + **React** | `react-ui/` | 后端同 `ruoyi`；前端 `react-ui/src/pages/{biz}/` | 同 ruoyi + 勿找 `ruoyi-ui` |
| `ruoyi-activiti` | Java + Vue + **Activiti** | `ruoyi-ui/` | CRUD 同 cloud；流程 `bpmn/`、`ruoyi-workFlow` | `ruoyi-activiti` 引擎集成层 |
| `ruoyi-process` | Java **Thymeleaf + Activiti** | 模板 | `templates/` + `ruoyi-activiti` 模块 API | 无 `ruoyi-ui`；勿当 Vue 版 |
| `django-vue-admin` | **Django** + DRF + Vue | `web/` | `backend/{biz}/` 或 `plugins/{biz}/` + `web/src/views/{biz}/` | `dvadmin/system` 核心 |
| `yi-netcore` | **.NET 8 ABP** + SqlSugar | 多 Vue 仓选一 | `Yi.Abp.Net8/module/` 或 ABP 分层 + 选定前端的 views/api | ABP 宿主、权限中间件 |
| `yisha` | **ASP.NET MVC Area** | 服务端渲染 | `Areas/{Biz}Manage/` + BLL/Service/Entity | `SystemManage` 堆业务、改全局 Filter |
| `gfast` | **GoFrame v2** | 随仓库 | 复制 `internal/app/system` → `internal/app/{biz}/` + `router` 注册 | `internal/app/system` 源码 |
| `yjgo` | **Go** JWT + Casbin | template 若有 | `app/controller|service|model` + `router/` | `boot/`、全局 middleware |
| `b5-laravel` | **Laravel** CMF | Admin 后台 | `app/Http/Controllers/Admin/{Biz}/` + migrations | `Admin/System`、基类权限链 |

详细路径、权限注解、一步清单 → **`distill/verified-{base-id}.md`**。

---

## 对照 Demo（写新功能前先打开）

| base-id | 建议先读 |
|---------|----------|
| `ruoyi` | `ruoyi-admin/.../demo/controller/DemoTableController` + `templates/demo/table/` |
| `ruoyi-cloud` | `ruoyi-modules/ruoyi-system` 任一 CRUD + `ruoyi-ui/src/views/system/user/` |
| `ruoyi-react` | `react-ui/src/pages/` 现有页 + `ruoyi-admin` 对应 REST Controller |
| `ruoyi-activiti` | `ruoyi-workFlow` + `ruoyi-ui` 流程相关 views |
| `ruoyi-process` | `ruoyi-admin/templates/` 审批页 + `ruoyi-activiti` Service |
| `django-vue-admin` | `backend/dvadmin/system/` 对照 + 独立 app 示例 |
| `yi-netcore` | `Yi.Abp.Net8/module/` + `Yi.RuoYi.Vue3/src/views/` |
| `yisha` | `Areas/OrganizationManage/Controllers/NewsController.cs` 全链路 |
| `gfast` | `internal/app/system/controller/` 整模块结构 |
| `yjgo` | `app/controller/` + `router/` 现有注册 |
| `b5-laravel` | `app/Http/Controllers/Admin/System/` + `Admin/Backend.php` |

---

## 权限与菜单（各基座差异）

| base-id | 后端权限 | 前端 |
|---------|----------|------|
| `ruoyi` / `ruoyi-process` | `@RequiresPermissions` | Thymeleaf 按钮 shiro 标签 |
| `ruoyi-cloud` / `ruoyi-activiti` / `ruoyi-react` | `@PreAuthorize` | `v-hasPermi` 或 React access |
| `django-vue-admin` | DRF `permission_classes` | 动态路由 + 按钮权限 |
| `yi-netcore` | ABP 权限定义 | 选定 Vue 项目内指令 |
| `yisha` | `[AuthorizeFilter("m:r:a")]` | 服务端按钮权限缓存 |
| `gfast` / `yjgo` | Casbin | 菜单表 + 前端路由 meta |
| `b5-laravel` | B5 节点权限 | 后台菜单配置 |

菜单数据：**SQL insert** 或基座自带菜单管理 —— 交付时必须 **本轮完成**，不得留给用户手动点。

---

## 代码生成（优先于手写 CRUD）

| base-id | 工具 |
|---------|------|
| `ruoyi` / cloud / react / activiti / process | `ruoyi-generator` |
| `gfast` | gen 表 / hack CLI |
| `yisha` | `YiSha.Util` CodeGenerator |
| `b5-laravel` | `Admin/Tool` 代码生成 |
| `django-vue-admin` | 按 dvadmin 插件/脚手架惯例 |
| `yi-netcore` | ABP 模块模板 |

生成后：**移动到业务包**、改包名/权限字/菜单，不要留在 generator 临时目录。

---

## Agent 强制检查（Step B）

- [ ] 已读 `distill/verified-{base-id}.md`
- [ ] 已在 `references/bases/{base-id}/` 打开上表 Demo 或同类文件
- [ ] 计划中的新增路径 **不在**「禁止大改」列
- [ ] 未假设 `ruoyi-ui`（仅 cloud/activiti 有）
- [ ] Thymeleaf 基座（`ruoyi`/`ruoyi-process`/`yisha`）未创建 `.vue` 当主 UI

同步/刷新基座：

```bash
bash scripts/sync-bases.sh {base-id}
bash scripts/distill-structure.sh {base-id}
```
