# verified · ruoyi-react

## 结构（已核实）

```
react-ui/          # React 管理端（非 Vue）
ruoyi-admin/       # Java 后端（同若依单体模块集）
ruoyi-system/
ruoyi-framework/
ruoyi-common/
ruoyi-generator/
ruoyi-quartz/
sql/
```

**无 `ruoyi-ui`**，前端在 `react-ui/`。

## 业务增量

- 后端：同 ruoyi 单体，Controller 在 `ruoyi-admin` 或新 module
- 前端：`react-ui/src/pages/{biz}/`、services、access 权限

## 一步交付

- [ ] REST API（JSON）+ React 页面 + 路由/权限
