# verified · gfast（tiger1103/gfast）

> 克隆分支：**os-v3.2**（仓库默认；用户链接 `tree/os-v2` 已下线，结构仍为 `internal/app/`）


```
main.go
internal/
  app/
    system/     # 内置系统：controller/logic/dao/model/router
    common/     # 字典、配置、Casbin
  router/
api/            # OpenAPI 定义
manifest/       # 配置、部署
resource/       # 静态/模板
hack/           # CLI 工具
library/
```

## 业务增量

复制 `internal/app/system` 模式，新建 `internal/app/{biz}/`：

```
{biz}/
  controller/
  logic/
  dao/ + dao/internal/
  model/entity/ + model/do/
  router/router.go
```

在 `internal/router/router.go` 注册。

## 权限

- Casbin（`app/common/service/casbin.go`）
- 菜单：`sys_auth_rule` 等表

## 代码生成

项目带 gen 表工具（`tools_gen_table` DAO）— 优先 CLI 生成

## 一步交付

- [ ] 完整 module 目录 + 菜单 SQL + 前端（若仓库含 web 则一并改）
