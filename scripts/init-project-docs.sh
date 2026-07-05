#!/usr/bin/env bash
# Bootstrap project documentation from ai-code-standard into target repo.
# Usage: init-project-docs.sh /path/to/project [project-name]
set -euo pipefail

TARGET="${1:-.}"
NAME="${2:-NewProject}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STANDARD_DIR="${SCRIPT_DIR}/../../ai-code-standard"
DATE="$(date +%Y-%m-%d)"

cd "${TARGET}"
mkdir -p sql doc

if [[ ! -f AI_RULE.md ]] && [[ -f "${STANDARD_DIR}/AI_RULE.md" ]]; then
  cp "${STANDARD_DIR}/AI_RULE.md" ./AI_RULE.md
  echo "Copied AI_RULE.md"
fi

if [[ ! -f README.md ]]; then
  cat > README.md <<EOF
# ${NAME}

## 项目介绍

（填写项目背景、业务目标、适用角色）

## 技术栈

- 后端：（填写）
- 前端：（填写）
- 数据库：（填写）
- 缓存/队列/对象存储：（填写，无则写无）

## 目录结构

（填写核心模块、前端页面、SQL、文档位置）

## 快速启动

1. 安装依赖：（填写）
2. 导入数据库：\`sql/${DATE}.sql\`
3. 启动后端：（填写）
4. 启动前端：（填写）

## 默认账号

（填写基座默认账号或初始化方式）

## 部署说明

（填写环境变量、端口、Nginx/Docker/systemd 等）

## 验收入口

（填写菜单、路由、接口、测试账号）

## 常见问题

（填写）
EOF
  echo "Created README.md"
fi

if [[ ! -f CONTRIBUTING.md ]]; then
  cat > CONTRIBUTING.md <<EOF
# 贡献与协作规范

## AI / 开发边界

- 只实现 requirement-map 和本轮任务明确包含的范围
- 禁止擅自重构基座 \`system\` / \`framework\` / \`core\` / 认证 / 全局返回
- 改接口、表结构、权限、配置、依赖时，必须同步对应文档
- 禁止提交真实密钥、生产账号、Token、私钥

## 分支与提交

- 功能：\`feature/{module}\`
- 修复：\`fix/{issue}\`
- 文档：\`docs/{topic}\`
- 提交信息说明本次变更范围

## PR / 交付检查

- [ ] 代码已自测
- [ ] SQL / migration 已提供
- [ ] README / 架构 / 功能 / 数据库 / API / CHANGELOG 已同步
- [ ] 安全与权限边界已检查
EOF
  echo "Created CONTRIBUTING.md"
fi

if [[ ! -f SECURITY.md ]]; then
  cat > SECURITY.md <<EOF
# 安全策略

## 支持范围

（填写当前支持版本或分支）

## 漏洞报告

请不要在公开 issue 中披露可利用细节。报告时提供：

- 影响版本/分支
- 复现步骤
- 影响范围
- 建议修复方向（如有）

## 敏感信息

- 禁止提交真实密钥、Token、生产账号、私钥
- 示例配置使用占位符
- 发现泄露后必须 rotate 密钥并记录在变更日志
EOF
  echo "Created SECURITY.md"
fi

if [[ ! -f CHANGELOG.md ]]; then
  cat > CHANGELOG.md <<EOF
# Changelog

> 面向用户/版本的变更记录。建议分组：Added / Changed / Fixed / Security / Breaking。

## Unreleased

### Added

- 初始化项目文档。

### Changed

### Fixed

### Security

### Breaking
EOF
  echo "Created CHANGELOG.md"
fi

if [[ ! -f AI_CHANGELOG.md ]]; then
  cat > AI_CHANGELOG.md <<EOF
# AI 修改记录

> 本文件只追加，不覆盖历史。

---

## AI-0001 ｜ $(date '+%Y-%m-%d %H:%M')

**项目**：${NAME}

**需求描述**：
（填写）

**修改文件**：
- （填写）

**自测结果**：
- [ ] 编译/检查通过
EOF
  echo "Created AI_CHANGELOG.md"
fi

if [[ ! -f .env.example ]]; then
  cat > .env.example <<EOF
# ${NAME} environment example
# 只写占位符，禁止提交真实密钥。

APP_ENV=local
APP_PORT=

DB_HOST=
DB_PORT=
DB_NAME=
DB_USER=
DB_PASSWORD=

REDIS_HOST=
REDIS_PORT=
REDIS_PASSWORD=
EOF
  echo "Created .env.example"
fi

if [[ ! -f AI_PROJECT.md ]]; then
  cat > AI_PROJECT.md <<EOF
# AI_PROJECT

> 项目：${NAME} · 初始化日期：${DATE}

## 基座来源

- base-id：（填写）
- 源码来源/commit：（填写）
- 本次是否复制基座：（是/否）

## 技术栈

| 层 | 技术 |
|----|------|
| 后端 | |
| 前端 | |
| 数据库 | |
| 缓存/队列/对象存储 | |

## 关键目录

| 目录 | 用途 |
|------|------|
| | |

## 启动方式

| 步骤 | 命令/说明 |
|------|-----------|
| 安装依赖 | |
| 导入 SQL | \`sql/${DATE}.sql\` |
| 启动后端 | |
| 启动前端 | |

## 验证记录

| 日期 | 命令 | 结果 |
|------|------|------|
| | | |
EOF
  echo "Created AI_PROJECT.md"
fi

if [[ ! -f AI_API.md ]]; then
  cat > AI_API.md <<EOF
# AI_API

> 项目：${NAME} · 初始化日期：${DATE}

## 接口约定

- 认证方式：（填写）
- 统一返回：（填写基座返回结构）
- 错误码：（填写）

## 接口清单

| 方法 | 路径 | 权限字 | 入参 | 返回 | 说明 |
|------|------|--------|------|------|------|
| | | | | | |

## 变更记录

| 日期 | 接口 | 变更 | 兼容性 |
|------|------|------|--------|
| | | | |
EOF
  echo "Created AI_API.md"
fi

if [[ ! -f AI_DATABASE.md ]]; then
  cat > AI_DATABASE.md <<EOF
# AI_DATABASE

> 项目：${NAME} · 初始化日期：${DATE}

## SQL 文件

- \`sql/${DATE}.sql\`

## 表 / 索引 / 缓存映射

| 表 | 用途 | 关键索引 | 关联缓存 key | 失效时机 |
|----|------|----------|--------------|----------|
| | | | | |

## 权限 / 菜单数据

| 菜单 | 权限字 | SQL 来源 |
|------|--------|----------|
| | | |

## 迁移与回滚

（填写幂等策略、回滚方式、不可逆说明）
EOF
  echo "Created AI_DATABASE.md"
fi

if [[ ! -f doc/ARCHITECTURE.md ]]; then
  cat > doc/ARCHITECTURE.md <<EOF
# 架构文档

> 项目：${NAME} · 初始化日期：${DATE}

## 基座与技术栈

- base-id：（填写）
- 后端：（填写）
- 前端：（填写）
- 数据库/缓存/队列/对象存储：（填写）

## 模块边界

| 模块 | 目录 | 职责 | 依赖 |
|------|------|------|------|
| | | | |

## 调用链

（按 P0 功能填写 Controller/API → Service → Repository/Mapper → DB/外部依赖）

## 权限模型

（角色、菜单、权限字、数据范围）

## 缓存 / 锁 / 异步

（Redis key、TTL、锁 A/B/C/D、MQ/DB Job；无则写无）

## 外部依赖

（第三方接口、文件存储、短信、支付等；无则写无）
EOF
  echo "Created doc/ARCHITECTURE.md"
fi

if [[ ! -f doc/requirement-map.md ]]; then
  cat > doc/requirement-map.md <<EOF
# 需求映射 · ${NAME} · ${DATE}

## 1. 基座与环境

- base-id：（填写）
- 语言：（填写）
- DB：（填写）
- 部署：（填写）

## 2. 本轮边界

- 本轮实现：
- 明确不做：
- 禁止改动核心域：

## 3. 功能清单

| ID | 模块 | 功能 | 类型 | 优先级 | 验收 |
|----|------|------|------|--------|------|
| | | | | | |

## 4. 数据模型

| 实体 | 表 | 说明 |
|------|----|------|
| | | |

## 5. 接口 / 页面 / 权限映射

| 功能 ID | API | 页面/菜单 | 权限字 | SQL |
|---------|-----|-----------|--------|-----|
| | | | | |

## 6. 风险与非功能

- 越权：
- Redis/缓存/锁：
- 并发/幂等：
- 导入导出：
- 工作流/异步：

## 7. 验收标准

- [ ] （填写）
EOF
  echo "Created doc/requirement-map.md"
fi

if [[ ! -f doc/FUNCTIONS.md ]]; then
  cat > doc/FUNCTIONS.md <<EOF
# 功能文档

> 项目：${NAME} · 初始化日期：${DATE}

## 角色

| 角色 | 能力 |
|------|------|
| | |

## 功能清单

| ID | 模块 | 功能 | 页面/菜单 | 接口 | 验收 |
|----|------|------|-----------|------|------|
| | | | | | |

## 业务流程

（填写主流程、状态机、异常流程）

## 页面说明

（填写列表、表单、详情、导入导出等）

## 验收用例

（填写账号、入口、操作、预期结果）
EOF
  echo "Created doc/FUNCTIONS.md"
fi

if [[ ! -f doc/DATABASE_SCHEMA.md ]]; then
  cat > doc/DATABASE_SCHEMA.md <<EOF
# 数据库 Schema

> 项目：${NAME} · 初始化日期：${DATE}

## SQL 文件

- \`sql/${DATE}.sql\`

## 表结构

### 表：{table_name}

| 字段 | 类型 | 必填 | 默认值 | 索引 | 说明 |
|------|------|------|--------|------|------|
| | | | | | |

## 枚举 / 字典

| 字典 | 值 | 说明 |
|------|----|------|
| | | |

## 菜单 / 权限数据

| 菜单 | 权限字 | 类型 | SQL 来源 |
|------|--------|------|----------|
| | | | |
EOF
  echo "Created doc/DATABASE_SCHEMA.md"
fi

if [[ ! -f doc/DATABASE_DESIGN.md ]]; then
  cat > doc/DATABASE_DESIGN.md <<EOF
# 数据库设计文档

> 项目：${NAME} · 初始化日期：${DATE}

## 实体关系

（填写 ER 关系、主外键、聚合边界）

## 状态机

（填写状态流转、禁止跳转规则；无则写无）

## 索引设计

| 表 | 索引 | 字段 | 目的 |
|----|------|------|------|
| | | | |

## 唯一约束 / 幂等

（填写防重复提交、回调去重、流水 UNIQUE）

## 数据归属 / 租户字段

（填写 user_id、tenant_id、project_id 等归属字段）

## 缓存映射

（填写 cache key、TTL、失效点；无则写无）
EOF
  echo "Created doc/DATABASE_DESIGN.md"
fi

touch "sql/${DATE}.sql"
echo "Created sql/${DATE}.sql"
echo "Project docs ready in ${TARGET}"
