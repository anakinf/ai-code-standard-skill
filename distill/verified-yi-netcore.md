# verified · yi-netcore（ccnetcore/yi）

## 结构（已核实）

```
Yi.Abp.Net8/           # .NET 8 ABP 后端
  src/
    Yi.Abp.Web/        # Web 入口
    Yi.Abp.Application/
    Yi.Abp.Domain/
    Yi.Abp.SqlSugarCore/
Yi.RuoYi.Vue3/         # 若依风格 Vue3 前端
Yi.Pure.Vue3/
Yi.Vben5.Vue3/
Yi.Bbs.Vue3/
module/                # 业务模块扩展
```

## 业务增量

- 后端：在 `Yi.Abp.Net8/module/` 或 `src/` 下按 ABP 分层新增 Application/Domain
- 前端：选 **一个** 与甲方约定的前端（默认 `Yi.RuoYi.Vue3`）
- ORM：SqlSugar（本项目）

## 一步交付

- [ ] 后端 API + 选定 Vue 项目内的 views/api
- [ ] 菜单/权限按 Yi 框架配置方式

## 注意

macOS 克隆可能有 ERP 路径大小写冲突 warning，以仓库实际文件为准。
