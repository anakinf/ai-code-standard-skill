# verified · ruoyi（y_project/RuoYi master）

> 克隆 commit: 见 manifest · **RuoYi v4.8.3 · Spring Boot 4.x 分支默认**

## 重要：这不是 Vue 分离版

README 明确：前后端分离请用 **RuoYi-Vue**（另一仓库）；本仓库是 **Thymeleaf + H+ 主题** 单体。

## Maven 模块（已核实）

```
ruoyi-admin      # Web 入口 + Controller + templates
ruoyi-framework  # 安全、配置、AOP
ruoyi-system     # 用户/角色/菜单/部门
ruoyi-common     # 工具、注解、基类
ruoyi-generator  # 代码生成
ruoyi-quartz     # 定时任务
sql/             # 初始化脚本
```

## 业务增量落点

| 层 | 路径 |
|----|------|
| Controller | `ruoyi-admin/src/main/java/com/ruoyi/web/controller/{biz}/` |
| Service | 新建 `ruoyi-{biz}` 模块 **或** 包 `com.ruoyi.{biz}` 在 admin/system |
| Mapper/XML | 同模块 `resources/mapper/` |
| 页面 | `ruoyi-admin/src/main/resources/templates/{biz}/*.html` |
| 静态 | `ruoyi-admin/src/main/resources/static/` |

参考 Demo：`com.ruoyi.web.controller.demo.controller.DemoTableController` + `templates/demo/table/`

## 权限

- 注解：`@RequiresPermissions("system:user:list")`（Shiro 风格，**非** `@PreAuthorize`）
- 菜单：`sys_menu` 表；perms 与注解一致

## 代码生成

`ruoyi-generator` → 生成 java/html/xml/sql → 将 **html 模板** 放入 templates，Java 放入对应包

## 一步交付必含

- [ ] Thymeleaf 列表/表单页（非 .vue）
- [ ] Controller + Service + Mapper
- [ ] `sql/` 菜单 insert
- [ ] `@RequiresPermissions` 每个接口

## 勿做

- ❌ 找 `ruoyi-ui/`（本仓库不存在）
- ❌ 假设 `@PreAuthorize`（除非已迁移 Spring Security）
