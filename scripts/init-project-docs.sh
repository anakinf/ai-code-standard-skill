#!/usr/bin/env bash
# Bootstrap project documentation from ai-code-standard into target repo.
# Usage: init-project-docs.sh /path/to/project [project-name]
set -euo pipefail

TARGET="${1:-.}"
NAME="${2:-NewProject}"
STANDARD_DIR="$(cd "$(dirname "$0")/../../ai-code-standard" && pwd)"
DATE="$(date +%Y-%m-%d)"

cd "${TARGET}"
mkdir -p sql doc

if [[ ! -f AI_RULE.md ]] && [[ -f "${STANDARD_DIR}/AI_RULE.md" ]]; then
  cp "${STANDARD_DIR}/AI_RULE.md" ./AI_RULE.md
  echo "Copied AI_RULE.md"
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

for f in AI_PROJECT.md AI_API.md AI_DATABASE.md; do
  if [[ ! -f "${f}" ]]; then
    echo "# ${f%.md}" > "${f}"
    echo "" >> "${f}"
    echo "> 由 ai-code-standard-skill 初始化于 ${DATE}" >> "${f}"
    echo "Created ${f}"
  fi
done

touch "sql/${DATE}.sql"
echo "Created sql/${DATE}.sql"
echo "Project docs ready in ${TARGET}"
