# 跨栈：边界 · 安全 · 性能（融合版）

与 [AI_RULE.md](../ai-code-standard/AI_RULE.md)、[architecture-patterns.md](../code-security-skill/architecture-patterns.md) 配合；基座落点见 `distill/verified-*.md`。

**本文件核心**：**业务越权** + **Redis（锁与缓存）**。高并发/MQ/异步网关等见 code-security-skill，不在此展开。

---

## 0. 首要目标

| 风险 | 见 |
|------|-----|
| 水平/垂直越权 | §2.1 |
| Redis 锁 TTL 乱用 | §3.1 |
| 缓存与锁混用、只改库不更缓存 | §3.2 |

普通 CRUD：**§2.1 + §3.2 查询缓存** 即可。有回调去重、提现连点、计数变更再加 **§3.1**。

## 0.1 内建原则

安全和性能不是交付后的审计附录，而是 Step C 规划、Step E-G 编码、Step K 复核的同一件事。

- 写接口先问「谁可以改谁的数据」，再写 Service
- 加缓存先问「命中后是否仍受权限范围约束」，再写 key
- 加锁先问「防并发、连点、在途还是重复做」，再定 TTL
- 加异步先问「DB Job 是否足够」，再考虑 MQ
- 加索引先问「列表筛选和唯一约束是什么」，再写 DDL

---

## 1. 模块边界（基座源码）

**权威索引**：[references/bases/README.md](references/bases/README.md) · 精修 [distill/verified-*.md](distill/verified-ruoyi.md)

| 原则 | 说明 |
|------|------|
| 先读基座 | 写码前必须在 `references/bases/{base-id}/` 对照 Demo（见 bases README） |
| 只增业务 | 新功能进独立包/模块/Area/views/API |
| 禁止大改 | 不改 `system` / `framework` / `core` / 认证 / 全局异常与返回结构 |
| 交付目录 | skill 内 `references/bases/` 只读；甲方项目 = 复制基座或增量到已有仓库 |

业务进增量模块；路径以 `verified-{base-id}.md` 为准。

---

## 2. 业务越权（必做）

### 2.1 规则

- [ ] 写接口默认登录；管理端走基座 RBAC（§5）
- [ ] **当前用户 ID 只从会话/Token 取**（如 `userService.getUser()`），**禁止**信请求体/query 里的 `userId`
- [ ] **按 ID 读写**：先查实体，再 `entity.userId == currentUser.id`（或租户/项目等价字段）；不通过则 403/404，不泄露是否存在
- [ ] **列表/统计**：WHERE 强制带 `currentUserId`（或 `@DataScope`），禁止客户端传 userId 过滤他人数据
- [ ] 管理端与用户端 API **分路径**；用户 token 不能调 admin 接口
- [ ] **Redis 缓存命中也须**走同一套归属校验，不能 skip

### 2.1.1 生产参考（Java H5 单体）

| 做法 | 位置（只读参考） |
|------|------------------|
| 登录拦截 `@AuthToken` | `xf-web/.../AuthorizationInterceptor.java` |
| 取当前用户 | `userService.getUser()`，非 request 参数 |
| 单条归属校验 | 如 `user.getId().equals(order.getUserId())`、`fundsApply.getUserid()` |
| **反例** | Service 列表若 `criteria.andUserIdEqualTo(request.getUserId())` 且 API 透传参数 → 越权风险 |

新接口：**列表强制 session userId**；**详情/写操作 load + compare**。

---

## 3. Redis

### 3.1 锁：按场景选 TTL（1 秒～7 天）

| 类 | 防什么 | TTL | 用法 |
|----|--------|-----|------|
| **A 并发** | 同时改同一行/同一资源 | **1～30s** | `tryLock` → 业务 → **`finally unlock`** |
| **B 防连点** | 重复提交 | **2～10s** | 用户/接口级短锁 |
| **C 在途** | 异步任务处理中 | **1～30min** | 终态后删 key |
| **D 防重复做** | 回调、重复补偿、不可逆操作 | **1h～7d** | 按渠道/对账窗口选；**须**配 DB 流水 UNIQUE |

- **A 不要用天级** → 业务长时间不可用  
- **D 不要用秒级** → 重投窗口内双做  
- Key 进统一注册表（如 `CacheConstants`）；**锁 key 与缓存 key 分前缀**  
- 实现：`SET NX` + 正确 TTL；**禁止**硬编码超大 TTL 再 `expire` 覆盖（参考项目 `RedisServiceImpl.tryLock` 为反例）

**生产 TTL 样例（抽象）**：B 10s · C 1h · D 8h · D 2～7d — [reference-java-monolith-redis.md](distill/reference-java-monolith-redis.md)

Step C：每个写接口标注 A/B/C/D 与 TTL 依据。

### 3.2 缓存（与锁分开）

| 用途 | TTL | 规则 |
|------|-----|------|
| 首页/字典/GeoIP 等查询 | 秒～小时 | 读：Redis → miss → DB → 回填 |
| 短信/验证码 | 分钟级 | 风控路径 Redis 不可用 → **503** |
| IP/接口限流 | 滑动窗口 | 可与 §3.1 B 配合 |

**写路径**：DB 提交成功后 **同一处** 更新/删除相关 cache key；禁止只改库。

Key 集中定义（`CacheConstants` 等价）；禁止 `KEYS *` 扫库删缓存。

---

## 4. MQ（**仅并发/异步需要时**）

**默认不用 MQ**。普通 CRUD、单体内同步写库 + §3 Redis 锁/缓存即可（与参考项目一致：无 Rabbit/Kafka，用 DB Job + Quartz 处理延迟）。

**满足以下之一再引入 MQ**（或 DB 任务表 + 调度，二选一）：

- 写入峰值明显，API 不能同步扛大表 insert
- 长时 Worker，需持久队列 + 多实例消费
- 外部回调/提交与主流程解耦且要 **confirm 后 ack**

| 要求 | 说明 |
|------|------|
| 不用 Redis List 当唯一队列 | 持久与对账靠 MQ 或 DB job 行 |
| 消费幂等 | D 类锁 + DB UNIQUE |
| 无 MQ 的异步 | DB `job` 表 + 定时任务 + C 类锁（参考项目 `JobServiceImpl`） |

细节见 [architecture-patterns.md §2.7](../code-security-skill/architecture-patterns.md)（**非**一步到位默认项）。

---

## 5. 各栈权限（基座）

| 基座 | 机制 |
|------|------|
| `ruoyi` | `@RequiresPermissions` / `@DataScope` |
| `ruoyi-cloud` 等 | `@PreAuthorize` / `v-hasPermi` |
| `django-vue-admin` | `CustomPermission` |
| `gfast` / `yjgo` | Auth + Casbin / middleware |
| `yisha` | `[AuthorizeFilter("m:r:a")]` |

---

## 6. 性能（简要）

分页、索引、禁止 N+1、外部 I/O 移出长事务。

| 场景 | 最低要求 |
|------|----------|
| 列表页 | WHERE 条件对应索引；默认分页；禁止全量导出替代分页 |
| 详情页 | 主表一次查清；关联多时批量查，避免循环查库 |
| 导入 | 校验错误可回显；大文件分批；失败不写半截脏数据 |
| 导出 | 大数据量走后台任务或分页流式；按权限范围导出 |
| 外部接口 | 超时、重试上限、幂等键；不要放在长事务内 |

---

## 7. 一步到位嵌入

| 步骤 | 内容 |
|------|------|
| C | 越权方式 + Redis 锁 A/B/C/D + TTL；**仅并发/async 需求**再列 MQ 或 DB Job |
| E | §2.1 + §3 Redis |
| K | §2.1 + §3；有 MQ 再查 §4 + code-security |

---

## 8. 参考

| 文档 | 用途 |
|------|------|
| [reference-java-monolith-redis.md](distill/reference-java-monolith-redis.md) | **越权 + Redis** 生产对照 |
| [architecture-patterns.md](../code-security-skill/architecture-patterns.md) | **仅并发/async 时** MQ 与异步 |
| [code-security/06.Redis安全.md](../code-security/06.Redis安全.md) | 缓存一致性细则 |

```bash
bash scripts/sync-bases.sh {base-id}   # 开源基座
```
