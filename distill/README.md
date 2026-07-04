# 基座蒸馏索引（来自真实克隆源码）

**上次全量同步**：见 `references/manifest.json`  
**本地路径**：`references/bases/{base-id}/` — **Agent 写码前必读** [references/bases/README.md](../references/bases/README.md)  
**自动快照**：`distill/{base-id}.md`（`bash scripts/distill-structure.sh --all`）  
**人工精修**：下列 `verified-*.md` 含落点与权限约定，**开发前必读对应文件**。

| base-id | 克隆 | 精修文档 | 实际类型（已核实） |
|---------|------|----------|-------------------|
| `ruoyi` | ✅ | [verified-ruoyi.md](verified-ruoyi.md) | **Thymeleaf 单体** v4.8.3，非 Vue 分离 |
| `ruoyi-cloud` | ✅ | [verified-ruoyi-cloud.md](verified-ruoyi-cloud.md) | Spring Cloud + `ruoyi-ui` Vue |
| `ruoyi-react` | ✅ | [verified-ruoyi-react.md](verified-ruoyi-react.md) | 后端同若依 + `react-ui` |
| `ruoyi-activiti` | ✅ | [verified-ruoyi-activiti.md](verified-ruoyi-activiti.md) | Vue `ruoyi-ui` + Activiti 模块 |
| `ruoyi-process` | ✅ | [verified-ruoyi-process.md](verified-ruoyi-process.md) | **Thymeleaf + Activiti**（本仓库无 ruoyi-ui） |
| `django-vue-admin` | ✅ | [verified-django-vue-admin.md](verified-django-vue-admin.md) | Django + `backend/dvadmin` + `web/` |
| `yi-netcore` | ✅ | [verified-yi-netcore.md](verified-yi-netcore.md) | ABP .NET 8 + 多 Vue 前端 |
| `gfast` | ✅ | [verified-gfast.md](verified-gfast.md) | GoFrame v2 · `internal/app/` |
| `yjgo` | ✅ | [verified-yjgo.md](verified-yjgo.md) | Go · `app/{controller,service,model}` |
| `b5-laravel` | ✅ | [verified-b5-laravel.md](verified-b5-laravel.md) | Laravel · `app/Http/Controllers/Admin` |
| `yisha` | ✅ | [verified-yisha.md](verified-yisha.md) | ASP.NET MVC **Area** + BLL/Service |

## Agent 强制步骤

1. 读 [references/bases/README.md](../references/bases/README.md) + `verified-{base-id}.md`  
2. **未指定基座** → [base-selection-prompt.md](../base-selection-prompt.md) 让用户选后再继续  
3. 在 **`references/bases/{base-id}/`** 打开对照 Demo  
4. [cross-cutting-constraints.md](../cross-cutting-constraints.md) §2 越权 + §3 Redis  
5. **禁止**凭记忆写路径；**禁止**大改 framework/system/core；**禁止**引用 skill 外项目路径

## 常见选型修正

| 用户说 | 实际应选 |
|--------|----------|
| Java + Vue 前后端分离 | `ruoyi-cloud`（含 ruoyi-ui）或 `ruoyi-activiti`；**不是** master `ruoyi` |
| Java + React 管理端 | `ruoyi-react` |
| Java + 页面模板一体 | `ruoyi` master（Thymeleaf） |
| .NET + Vue | `yi-netcore`（Yi.RuoYi.Vue3 / Yi.Pure.Vue3） |
| .NET + MVC 服务端渲染 | `yisha`（Area + AuthorizeFilter） |
| 工作流 | `ruoyi-activiti`（Vue）或 `ruoyi-process`（Thymeleaf 工作流） |

## 更新基座

```bash
bash scripts/sync-bases.sh --all      # 或单个 base-id
bash scripts/distill-structure.sh --all
# 若目录结构大变，人工修订 distill/verified-*.md
```
