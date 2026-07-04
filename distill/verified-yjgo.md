# verified · yjgo

## 结构（已核实）

```
main.go
app/
  controller/
  service/
  model/
  task/
  utils/
boot/           # 启动、配置加载
router/         # 路由注册
config/
template/       # 模板（若有后台页）
public/
document/
```

## 业务增量

- `app/controller/{biz}_controller.go`
- `app/service/{biz}_service.go`
- `app/model/{biz}.go`
- `router/` 注册路由
- JWT + Casbin（读现有 middleware 复用）

## 一步交付

- [ ] Go 编译通过 + API + 若带 admin 模板则 template 页
- [ ] 权限/Casbin policy 或菜单 seed
