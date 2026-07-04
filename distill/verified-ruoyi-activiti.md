# verified · ruoyi-activiti

## 结构（已核实）

```
ruoyi-ui/              # Vue 前端
ruoyi-activiti/        # Activiti 集成
ruoyi-workFlow/        # 工作流业务
ruoyi-admin/
ruoyi-system/
...（同若依）
bpmn/                  # 流程模型资源
```

## 业务增量

- 普通 CRUD：参照 ruoyi-cloud 的 ruoyi-ui 落点
- 流程：BPMN 放 `bpmn/` 或 activiti modeler；业务表加 `process_instance_id`
- 模块：`ruoyi-workFlow` 扩展工作流相关 API

## 权限

Vue 版通常 `@PreAuthorize` + `v-hasPermi`（以仓库内现有 Controller 为准）

## 一步交付

- [ ] 含流程时：模型/表单/审批接口 + Vue 页
- [ ] 普通业务仍须完整 CRUD + 菜单
