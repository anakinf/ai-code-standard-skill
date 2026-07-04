# verified · ruoyi-process

## 结构（已核实）

```
ruoyi-activiti/
ruoyi-admin/
ruoyi-system/
...（无 ruoyi-ui 目录）
bpmn/
screenshot/
```

README：**RuoYi 4.x + Activiti 6.x + Thymeleaf** 工作流管理系统（闲鹿技术 fork）。

## 与 ruoyi-activiti 区别

| 项 | ruoyi-process | ruoyi-activiti |
|----|---------------|----------------|
| 前端 | Thymeleaf 模板 | ruoyi-ui Vue |
| 场景 | 传统 MVC 工作流 | 前后端分离 + 工作流 |

## 业务落点

- 页面：`ruoyi-admin/.../templates/`
- 流程：`ruoyi-activiti` 模块 Controller/Service
- 权限：`@RequiresPermissions`（Thymeleaf 系）

## 一步交付

- [ ] HTML 审批/申请页 + 流程定义 + 菜单 SQL
