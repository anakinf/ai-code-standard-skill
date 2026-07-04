# verified · ruoyi-cloud

## 结构（已核实）

```
ruoyi-gateway/     # 网关
ruoyi-auth/        # 认证中心
ruoyi-api/         # Feign API 定义
ruoyi-modules/     # 业务微服务
  ruoyi-system/
  ruoyi-gen/
  ruoyi-job/
  ruoyi-file/
ruoyi-ui/          # Vue 前端（前后端分离）
ruoyi-visual/      # 监控
sql/
```

## 业务增量

1. 在 `ruoyi-modules/` 新建 `ruoyi-{biz}` 微服务
2. 在 `ruoyi-api/` 建对应 Feign 接口模块
3. 网关 `ruoyi-gateway` 增加路由
4. 前端 `ruoyi-ui/src/views/{biz}/`、`src/api/{biz}/`

## 权限

- 后端：`@PreAuthorize`（Spring Security，与单体 Thymeleaf 版不同）
- 前端：`v-hasPermi`

## 一步交付

- [ ] 微服务可启动 + 网关路由 + Nacos 配置说明
- [ ] ruoyi-ui 页面 + 菜单 SQL
- [ ] Feign/API 模块若跨服务调用
