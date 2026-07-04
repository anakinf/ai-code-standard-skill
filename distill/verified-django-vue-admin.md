# verified · django-vue-admin

## 结构（已核实）

```
backend/
  application/       # Django 项目配置
  conf/
  dvadmin/           # 核心：system 等
    system/          # 用户角色菜单
    utils/
  plugins/           # 插件扩展点
  manage.py
web/                 # Vue 前端
docker-compose.yml
```

## 业务增量

| 层 | 路径 |
|----|------|
| App | `backend/{biz}/` 或 `backend/plugins/{biz}/` |
| Model/Serializer/View | Django 常规 + DRF |
| 前端 | `web/src/views/{biz}/`、`web/src/api/` |
| 路由 | `web/src/router` + 后台菜单 API |

## 权限

- DRF `permission_classes`；菜单在 dvadmin system 模块配置

## 一步交付

- [ ] migrations + `sql/` 导出（若需要）
- [ ] 后端 API + Vue 页 + 菜单/角色配置说明
