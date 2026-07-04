# verified · b5-laravel-cmf

## 结构（已核实）

```
app/
  Http/Controllers/
    Admin/           # 后台
      System/        # 菜单、角色、管理员
      Tool/          # 代码生成、上传
    Api/V1/          # 对外 API
  Models/
  Extends/
routes/
database/migrations/
resources/
```

## 业务增量

| 层 | 路径 |
|----|------|
| 后台 Controller | `app/Http/Controllers/Admin/{Biz}Controller.php` |
| Model | `app/Models/` |
| Service | `app/Extends/` 或 `app/Services/`（按现有惯例） |
| 迁移 | `database/migrations/` |

基类：`Admin/Backend.php`、`Api/Api.php`

## 权限

- B5 节点权限；菜单后台配置或 Seeder

## 一步交付

- [ ] Migration + Controller + 后台视图/JSON API
- [ ] 菜单节点 SQL/Seeder
