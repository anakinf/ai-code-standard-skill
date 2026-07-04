# verified · yisha（YiShaAdmin）

> 克隆 commit: `8881dd9` · 源：`gitee.com/liukuo362573/YiShaAdmin`（GitHub 不稳定时用 Gitee）

## 架构（已核实）

ASP.NET Core **MVC + Area** 单体；另有 `YiSha.Admin.WebApi` 供移动端 API。

```
YiSha.Entity/          # Entity + Model/Param + Enum
YiSha.Business/
  YiSha.Service/       # 数据访问 Service
  YiSha.Business/      # BLL 业务层
  YiSha.Business.Cache/# 菜单/字典等缓存
YiSha.Data/            # EF + Repository
YiSha.Web/
  YiSha.Admin.Web/     # MVC 管理端（Areas）
  YiSha.Admin.WebApi/  # Web API
YiSha.Util/            # 工具 + CodeGenerator
Document/DatabaseScript/
```

## 业务增量落点

| 层 | 路径 |
|----|------|
| Area + Controller | `YiSha.Web/YiSha.Admin.Web/Areas/{Biz}Manage/Controllers/` |
| 视图 | `Areas/{Biz}Manage/Views/{Controller}/` |
| BLL | `YiSha.Business/YiSha.Business/{Biz}Manage/{Entity}BLL.cs` |
| Service | `YiSha.Business/YiSha.Service/{Biz}Manage/{Entity}Service.cs` |
| Entity | `YiSha.Entity/YiSha.Entity/{Biz}Manage/` |
| Param | `YiSha.Entity/YiSha.Model/Param/{Biz}Manage/` |
| SQL | `Document/DatabaseScript/` |

参考：`Areas/OrganizationManage/Controllers/NewsController.cs` + `OrganizationManage/NewsBLL`

## 权限（源码核实）

| 机制 | 位置 |
|------|------|
| 登录 + 按钮权限 | `[AuthorizeFilter("module:resource:action")]` |
| Filter 实现 | `YiSha.Admin.Web/Filter/AuthorizeFilterAttribute.cs` |
| 菜单权限缓存 | `MenuAuthorizeBLL` + `MenuAuthorizeCache` |
| 未登录 Ajax | 返回 JSON `抱歉，没有登录或登录已超时` |
| 无权限 | JSON `抱歉，没有权限` 或跳转 `~/Home/NoPermission` |
| SaveFormJson | 自动区分 add/edit 子权限（`:add` / `:edit` 后缀） |
| 全局异常 | `GlobalExceptionFilter`（Admin.Web `Startup.cs` 注册） |
| WebApi | 独立 `AuthorizeFilterAttribute`（`Admin.WebApi/Filter/`） |

权限字示例：`organization:news:view`、`organization:news:search`、`tool:server:view`

## 分页

`GetPageListJson(..., Pagination pagination)` — 抄 `NewsController` 分页参数与 BLL 调用。

## 一步交付必含

- [ ] 新 **Area** 或扩展现有 Area（如 `{Biz}Manage`）
- [ ] Controller + BLL + Service + Entity + Param
- [ ] 每个 Action `[AuthorizeFilter("...")]`（含 list/save/delete）
- [ ] 菜单/权限 SQL（与 Authorize 字符串一致）
- [ ] Thymeleaf/Razor 视图（本基座为 **服务端渲染**，非独立 Vue 仓库）

## 勿做

- ❌ 把甲方 CRUD 堆进 `SystemManage` 核心 Controller
- ❌ 新建接口无 `AuthorizeFilter`（裸 `[AuthorizeFilter]` 无参仅校验登录）
- ❌ 与 `yi-netcore` 混淆：yisha 是经典 MVC 分层；yi 是 ABP 模块化

## 与 yi-netcore 选型

| 场景 | 推荐 |
|------|------|
| .NET MVC + Area + 代码生成器习惯 | **yisha** |
| ABP + SqlSugar + 多 Vue 前端 | **yi-netcore** |
