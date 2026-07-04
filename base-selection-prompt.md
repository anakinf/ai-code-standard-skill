# 基座选型 · 用户确认（Step B 必做）

用户给需求但**未明确语言/基座**时，Agent **先展示本页选项、等用户输入**，**禁止**默认猜基座后直接写码。

用户已明确（如「用 ruoyi-cloud 做」）→ 复述确认一句即可，跳过问卷。

---

## Agent 必做

1. 用 **AskQuestion**（或等价结构化选项）让用户选 **语言** → **基座 base-id**
2. 每个选项附带 **一句话架构**（下表原文，勿加长）
3. 用户选定后写入 `requirement-map.md` 的 `base-id`，再读 `references/bases/{base-id}/` + `verified-*.md`
4. 若需求含 **工作流/审批** 且用户选了无流程基座 → 二次提示改选 `ruoyi-activiti` / `ruoyi-process`

---

## 展示模板（复制给用户）

```markdown
请先选 **开发语言** 和 **基座源码**（业务只增不改框架 core）：

### Java
| base-id | 一句话架构 |
|---------|------------|
| **ruoyi-cloud** | 微服务：gateway + auth + `ruoyi-modules` + **Vue** `ruoyi-ui` |
| **ruoyi-activiti** | 若依 Vue 分离 + **Activiti 工作流** |
| **ruoyi** | **Thymeleaf 单体**（无 ruoyi-ui，页面在 templates） |
| **ruoyi-react** | 若依后端 + **React** `react-ui` |
| **ruoyi-process** | **Thymeleaf + Activiti** 工作流（无 Vue） |

### Python
| base-id | 一句话架构 |
|---------|------------|
| **django-vue-admin** | Django/DRF `backend/dvadmin` + **Vue** `web/` |

### .NET
| base-id | 一句话架构 |
|---------|------------|
| **yi-netcore** | **ABP .NET 8** + SqlSugar，多 Vue 前端（默认 Yi.RuoYi.Vue3） |
| **yisha** | **ASP.NET MVC Area** 服务端渲染 + BLL/Service 分层 |

### Go
| base-id | 一句话架构 |
|---------|------------|
| **gfast** | **GoFrame v2**：`internal/app/{biz}` controller/logic/dao |
| **yjgo** | Go 单体：`app/controller` + service + **Casbin** |

### PHP
| base-id | 一句话架构 |
|---------|------------|
| **b5-laravel** | **Laravel** CMF：`Admin/` 后台 + migrations |

请回复：**语言 + base-id**（例：`Java · ruoyi-cloud`）。  
已有项目目录可一并说明路径。
```

---

## AskQuestion 配置（Agent 内部）

**问题 1 · 语言**（单选）

| id | label |
|----|-------|
| `java` | Java |
| `python` | Python |
| `dotnet` | .NET |
| `go` | Go |
| `php` | PHP |

**问题 2 · 基座**（按语言动态；单选，label 含架构摘要）

### Java

| id | label |
|----|-------|
| `ruoyi-cloud` | ruoyi-cloud — 微服务 + Vue ruoyi-ui（推荐前后端分离） |
| `ruoyi-activiti` | ruoyi-activiti — Vue + Activiti 工作流 |
| `ruoyi` | ruoyi — Thymeleaf 单体，无 ruoyi-ui |
| `ruoyi-react` | ruoyi-react — 后端 + React react-ui |
| `ruoyi-process` | ruoyi-process — Thymeleaf + Activiti 工作流 |

### Python

| id | label |
|----|-------|
| `django-vue-admin` | django-vue-admin — Django dvadmin + Vue web |

### .NET

| id | label |
|----|-------|
| `yi-netcore` | yi-netcore — ABP .NET 8 + Vue（Yi.RuoYi.Vue3） |
| `yisha` | yisha — MVC Area 服务端渲染 + BLL/Service |

### Go

| id | label |
|----|-------|
| `gfast` | gfast — GoFrame internal/app 模块化 |
| `yjgo` | yjgo — Go 单体 controller/service + Casbin |

### PHP

| id | label |
|----|-------|
| `b5-laravel` | b5-laravel — Laravel Admin CMF |

---

## 选型速查

| 用户想要 | 推荐 base-id |
|----------|--------------|
| Java 管理后台 + Vue | `ruoyi-cloud` |
| 请假/审批/BPMN | `ruoyi-activiti`（Vue）或 `ruoyi-process`（Thymeleaf） |
| 老项目一体页、不要前后端分离 | `ruoyi` |
| React 管理端 | `ruoyi-react` |
| Python 全栈 | `django-vue-admin` |
| .NET 现代模块化 + Vue | `yi-netcore` |
| .NET 传统 MVC | `yisha` |
| Go 企业后台 | `gfast`（偏框架）/ `yjgo`（偏轻量） |
| PHP | `b5-laravel` |

源码路径：`references/bases/{base-id}/` · 细节：`distill/verified-{base-id}.md`
