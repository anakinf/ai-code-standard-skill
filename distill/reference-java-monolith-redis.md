# 参考 · 越权 + Redis（Java 单体）

> 来源：`/Users/fengshufang/Documents/工作/2022/淘淘收卡/server`（只读，**不含业务逻辑**）  
> 与 [cross-cutting-constraints.md](../cross-cutting-constraints.md) §2.1、§3 对应

---

## 1. 业务越权

### 已用模式

| 模式 | 文件 |
|------|------|
| `@AuthToken` 标记需登录 | `xf-web/.../annotation/AuthToken.java` |
| 拦截器校验登录 | `xf-web/.../interceptor/AuthorizationInterceptor.java` → `userService.getUser()` |
| 单条数据归属 | `FundsApplyController`：`user.getId().equals(fundsApply.getUserid())` |
| 订单归属 | `AlipayRecyclCreateController`：`user.getId().equals(order.getUserId())` |

### 须改进（写入 skill 反例）

| 风险 | 说明 |
|------|------|
| 只验登录不验归属 | 拦截器不代替「按 ID 读写」 |
| 列表透传 `userId` | `OrderServiceImpl` 等若用 `request.getUserId()` 且 API 未强制 session → 可查他人数据 |
| 管理端与用户端混用 | admin 用 Shiro，H5 用 `@AuthToken`，新接口须明确一侧 |

### 新功能 checklist

- [ ] 列表：`WHERE user_id = 当前会话用户`
- [ ] 详情/改/删：load 后 `entity.userId == currentUser.id`
- [ ] 不信 body/query 的 `userId`
- [ ] 缓存数据返回前仍校验归属

---

## 2. Redis 锁（实测 TTL，抽象）

| 类 | 秒数 | 场景（抽象） |
|----|------|--------------|
| B | 1～10 | 绑卡、提现申请、下单防连点 |
| C | 3600 | 延迟任务 `proJob_{id}` |
| D | 3600～28800 | 渠道回调去重（宜收口一个 Service，勿 12 处 copy） |
| D | 172800～604800 | 不可逆审核/管理标记（**2～7 天**） |

封装：`RedisService.tryLock` / `unlock` — 注意实现中 **TTL 硬编码与 `*10000` 租约** 为反例，新代码用明确 `second` + `SET NX EX`。

Key 前缀：`CacheConstants`（如 `CALLBACKORDERREPEATSUB_`）。

---

## 3. Redis 缓存（非锁）

| 用途 | TTL 量级 | 文件线索 |
|------|----------|----------|
| 短信验证码 | ~30min | `MobileServiceImpl` |
| 日发送次数 | 至当日结束 | `today_phone_code_times_*` |
| IP 发码限流 | 120s / 5次 | `ipsendcount_*` |
| 首页数据 | 30s | `HomeController` |
| 页面 IP 限流 | 1min / 500 | `RateLimitInterceptor` |
| 提交频率 | 1min / 5 | `OrderServiceImpl` `send_cardlimit_*` |

**原则**：锁 key ≠ 缓存 key；改库后删/更新对应 cache。

---

## 4. 异步（无 MQ 时的对照）

参考项目用 **DB job 表 + Quartz**（`JobServiceImpl.proJob`），不是 MQ。  
**仅**需求有并发峰值/多机 Worker 时再选 MQ — 见 cross-cutting §4、architecture-patterns。
