# 使用示例

## 示例 0：只有需求，未选基座（标准开场）

**用户**：「这是订单管理需求，一步到位。」

**Agent**（**先不写码**）：

1. 展示 [base-selection-prompt.md](base-selection-prompt.md) 语言/基座表（各 base-id 一句话架构）
2. **AskQuestion** 让用户选，或等回复 `Java · ruoyi-cloud`
3. 确认后写 requirement-map，再读 `references/bases/ruoyi-cloud/` 开干
4. 交付时说明参照了哪个 `verified-*.md` 和哪个 Demo

## 示例 1：有若依源码 + 需求文档

**用户**：「这是需求 doc/客户A-订单.md，项目在 `/work/RuoYi`，一步到位做完。」

**Agent**：

1. 读 `AI_RULE.md` + 本 skill
2. 写 `doc/requirement-map.md`
3. 新建 `ruoyi-modules/ruoyi-order`，generator 或手建 CRUD
4. `sql/2026-07-04.sql` + menu SQL
5. `ruoyi-ui/src/views/order/` + api + 路由
6. `README.md` + `CONTRIBUTING.md` + `SECURITY.md` + `CHANGELOG.md`
7. `doc/ARCHITECTURE.md` + `doc/FUNCTIONS.md` + `doc/DATABASE_SCHEMA.md` + `doc/DATABASE_DESIGN.md`
8. `AI_CHANGELOG.md` + `AI_API.md` + `AI_DATABASE.md` + `AI_PROJECT.md`
9. `mvn compile` + one-shot-delivery 自检
10. `@code-security-audit` 增量扫 order 模块

**关键思想**：订单列表不能信 query 里的 `userId`；详情/改状态先 load 订单再比对归属；支付/回调类操作加 D 类幂等锁和 DB UNIQUE。

## 示例 2：无源码，要 Python

**用户**：「做学员管理系统，Python，没代码。」

**Agent**：

```bash
bash .../ai-code-standard-skill/scripts/sync-bases.sh django-vue-admin
```

1. base-id = `django-vue-admin`
2. requirement-map：学员、班级、课程 CRUD
3. `backend/student/` + migrations + `web/src/views/student/`
4. 角色：教务/教师；菜单 API 配置
5. 一步交付清单全勾

## 示例 3：.NET 项目

**用户**：「用 .NET 做资产台账，要 YiSha。」

1. sync `yisha`
2. 新 Controller/Service/Entity 按 stack-guides .NET 节
3. 前端 Vue 页 + 菜单
4. `dotnet build`

## 示例 4：Go + 工作流（选错基座纠正）

需求含「请假审批流」→ base 改为 `ruoyi-activiti` 或 `ruoyi-process`，**不要**在纯 RuoYi 单体上手写简易 flow。

## 联动其他 skill

| 场景 | 调用 |
|------|------|
| Java 模块边界拿不准 | `@xf-app-assistant` 参考落点，映射到 ruoyi-{biz} |
| 交付前安全 | `@code-security-audit` 增量 |
| 编码规范细节 | `../ai-code-standard/AI_RULE.md` |

## 反例（不要这样）

- 只生成 Entity/Mapper，说「前端你们自己做」
- 只生成代码，不生成 README、架构文档、功能文档、数据库 schema/设计文档
- 改了表字段、接口、权限或配置，却没有同步 DATABASE_SCHEMA、AI_API、README、CHANGELOG
- 为了做业务顺手重构基座 core/system/framework
- 把业务代码全塞进 `ruoyi-system` 的 `SysUserController`
- 未导入菜单就说「功能已完成」
- 分两次对话：「这次先做表，下次做接口」
- 未指定基座时默认猜 `ruoyi`，结果给 Vue 路径 `ruoyi-ui`
- 只看蒸馏文档，不打开真实 `references/bases/{base-id}` Demo
