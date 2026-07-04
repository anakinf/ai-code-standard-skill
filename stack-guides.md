# 各栈落点指南

与 [base-catalog.md](base-catalog.md)、**[references/bases/README.md](references/bases/README.md)** 配合。  
**写任何路径前**须在 `references/bases/{base-id}/` 打开同类 Demo；冲突时以克隆仓库为准并记入 CHANGELOG。

## Java · RuoYi 单体（base-id: `ruoyi` · Thymeleaf）

> **无 `ruoyi-ui`**。Vue 分离用 `ruoyi-cloud`。Demo：`references/bases/ruoyi/.../demo/DemoTableController`

### 业务模块骨架（二选一）

**A. 包在 admin（小功能）**

```text
ruoyi-admin/src/main/java/com/ruoyi/web/controller/{biz}/
ruoyi-admin/src/main/resources/templates/{biz}/
```

**B. 独立 Maven 模块（推荐稍大业务）**

```text
ruoyi-{biz}/
├── pom.xml
└── src/main/java/com/ruoyi/{biz}/controller|domain|mapper|service/
    resources/mapper/{biz}/*.xml
```

根 `pom.xml` 加 module；`ruoyi-admin` 依赖 `ruoyi-{biz}`。

### 权限与菜单

- 注解：`@RequiresPermissions("biz:entity:list")`（**不是** `@PreAuthorize`）
- 页面：Thymeleaf `templates/{biz}/`，非 `.vue`
- SQL：`sys_menu` + perms 与注解一致

### 代码生成

`ruoyi-generator` → 导入表 → 生成 → 移动到 `ruoyi-{biz}` → 全局替换包名

### 联动 xf-app-assistant 映射

| 星飞 | RuoYi |
|------|-------|
| `xf-app/.../web/controller` | `ruoyi-{biz}/controller`（管理 API） |
| `xf-app/.../app/controller` | 若有 C 端：独立 `controller/app` 或 `ruoyi-api` |
| 禁止改 `xf-system` | 禁止改 `ruoyi-system` 域逻辑 |

### 外部回调 + Redis

见 [cross-cutting-constraints.md](cross-cutting-constraints.md) §2.1、§3：越权、`CacheConstants`、锁 A/B/C/D。**无 MQ 时用 DB Job + 基座调度**；仅流量/多机不够再上 MQ（§4）。

---

## Java · RuoYi-Cloud（`ruoyi-cloud`）

- 新服务：`ruoyi-modules/ruoyi-{biz}` + `ruoyi-api/ruoyi-api-{biz}`（Feign）
- 网关 `ruoyi-gateway` 加路由；Nacos 配置 dataId
- **一步交付**仍要：服务可启动 + 网关可达 + 前端 API 前缀改对

---

## Java · 工作流（`ruoyi-activiti` / `ruoyi-process`）

- 流程定义 BPMN 放 `resources/processes/` 或设计器导出
- 业务表 + 流程实例关联字段 `process_instance_id`
- 审批接口走 workflow service，**不在 Controller 硬改状态**

---

## Java · React 管理端（`ruoyi-react`）

- 后端同 RuoYi；前端 `src/pages/` + `access.ts` 权限
- Ant Design Pro 路由；API 与 Vue 版共用

---

## Python · django-vue-admin（`django-vue-admin`）

```text
backend/{biz}/
├── models.py
├── serializers.py
├── views.py
├── urls.py
└── filters.py          # 若有
web/src/views/{biz}/
├── index.vue
└── components/
```

- 注册 `INSTALLED_APPS`；`urls.py` include
- 权限：`CustomPermission` / 角色菜单 API
- Migration：`python manage.py makemigrations` → 导出 SQL 到 `sql/` 供生产

---

## .NET · YiShaAdmin（`yisha`）

- `YiSha.Admin.WebApi` Controllers
- `YiSha.Service` / `YiSha.Entity` / `YiSha.Business`
- 新域：文件夹 + Autofac 注册（按仓库惯例）
- 菜单：数据库或 `menu.json` 配置

## .NET · ccnetcore/yi（`yi-netcore`）

- 模块化：`Yi.{Module}` 类库
- 统一 AOP、鉴权过滤器 — **扩展模块不复制过滤器**

---

## Go · gfast（`gfast`）

```text
internal/app/{biz}/
├── controller/
├── logic/
├── model/entity + do
└── router/router.go
```

- CLI 生成：`gf gen ...` 按项目文档
- 路由在 `router` 注册；中间件链勿 duplicate JWT

## Go · yjgo（`yjgo`）

- `server/app/{biz}/` 控制器 + service + model
- Casbin policy CSV 或 DB；菜单 seed

---

## PHP · b5-laravel-cmf（`b5-laravel`）

```text
app/Admin/Controller/{Biz}Controller.php
app/Common/Model/{Biz}.php
app/Common/Service/{Biz}Service.php
database/migrations/
```

- 后台菜单：`b5net` 菜单表 insert
- 验证：FormRequest；**禁止** `$request->all()` 直写库

---

## 跨栈统一约定（AI_RULE + code-security）

| 项 | 要求 |
|----|------|
| 分层 | Controller 薄；事务在 Service |
| 返回 | 用基座统一包装，禁止自创 JSON 形状 |
| 分页 | 用基座 PageHelper / DRF pagination / gf Page |
| 并发写 | Redis 锁 + 越权（cross-cutting §2–3）；MQ 见 §4 **按需** |
| SQL | 参数化；DDL 进 `sql/YYYY-MM-DD.sql` |
| 异常 | 全局 handler；不向前端吐栈 |
| 日志 | 无明文密码/Token |

---

## 前端共性（Vue 系）

- API：`src/api/{biz}/{entity}.js` 封装
- 列表：queryParams + 分页 + 权限按钮
- 表单：rules 校验与后端 DTO 对齐
- 字典：用基座 dict 组件，不硬编码枚举展示

## React（ruoyi-react）

- `services/{biz}` + `pages/{biz}/` + ProTable/ProForm
