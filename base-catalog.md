# 开源基座目录（与本地克隆同步）

**本地克隆**：`references/bases/` · **commit 记录**：`references/manifest.json`  
**蒸馏文档**：`distill/verified-*.md`（开发前必读）

## 克隆状态（2026-07-04 本机核实）

| base-id | 仓库 | 克隆 | 核实结论 |
|---------|------|------|----------|
| `ruoyi` | gitee.com/y_project/RuoYi | ✅ | **Thymeleaf 单体 v4.8.3**，无 ruoyi-ui |
| `ruoyi-cloud` | gitee.com/y_project/RuoYi-Cloud | ✅ | 微服务 + **ruoyi-ui** Vue |
| `ruoyi-react` | gitee.com/whiteshader/ruoyi-react | ✅ | **react-ui** + Java 后端 |
| `ruoyi-activiti` | gitee.com/smell2/ruoyi-vue-activiti | ✅ | **ruoyi-ui** + Activiti |
| `ruoyi-process` | gitee.com/calvinhwang123/RuoYi-Process | ✅ | Thymeleaf + Activiti，无 ruoyi-ui |
| `django-vue-admin` | gitee.com/liqianglog/django-vue-admin | ✅ | backend/dvadmin + web |
| `yi-netcore` | gitee.com/ccnetcore/yi | ✅ | Yi.Abp.Net8 + 多 Vue 前端 |
| `gfast` | gitee.com/tiger1103/gfast | ✅ | GoFrame internal/app |
| `yjgo` | github.com/guolingege/yjgo | ✅ | app/controller/service |
| `b5-laravel` | gitee.com/b5net/b5-laravel-cmf | ✅ | Laravel Admin/Api |
| `yisha` | gitee.com/liukuo362573/YiShaAdmin | ✅ | ASP.NET MVC **Area** + BLL/Service，无独立 Vue 仓 |

## 决策树

见 [distill/README.md](distill/README.md)

## 更新命令

```bash
bash scripts/sync-bases.sh ruoyi          # 单个
bash scripts/sync-bases.sh --all          # 全部
bash scripts/distill-structure.sh --all # 刷新目录快照
# 结构变化大时：人工改 distill/verified-*.md
```

## 与初版文档的重要差异（已按源码修正）

1. **`RuoYi` ≠ RuoYi-Vue**：master 是 Thymeleaf；Vue 分离在 `ruoyi-cloud/ruoyi-ui` 或 `ruoyi-activiti/ruoyi-ui`
2. **权限注解**：Thymeleaf 系用 `@RequiresPermissions`；Cloud/Vue 系用 `@PreAuthorize`
3. **ruoyi-process** 本仓库是 MVC 工作流，不是 Vue 分离（README 写 Thymeleaf + Activiti）
4. **gfast** 业务在 `internal/app/{biz}/`，不是 `internal/app/system` 改源码
5. **yi-netcore** 含多个前端仓库，交付前与甲方定一个（默认 Yi.RuoYi.Vue3）

## 详细落点

- **总索引**：[references/bases/README.md](references/bases/README.md)（11 基座结构 + Demo + 禁止大改）
- **单基座**：`distill/verified-{base-id}.md`
