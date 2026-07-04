#!/usr/bin/env bash
# Generate distill/{base-id}.md from cloned references/bases/{base-id}
# Usage: distill-structure.sh [base-id|--all]
set -eo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BASES="${SKILL_DIR}/references/bases"
DISTILL="${SKILL_DIR}/distill"
MANIFEST="${SKILL_DIR}/references/manifest.json"

mkdir -p "${DISTILL}"

distill_one() {
  local id="$1"
  local src="${BASES}/${id}"
  local out="${DISTILL}/${id}.md"
  if [[ ! -d "${src}" ]]; then
    echo "SKIP ${id}: not cloned at ${src}" >&2
    return 1
  fi
  local commit synced
  if command -v python3 >/dev/null 2>&1 && [[ -f "${MANIFEST}" ]]; then
    read -r commit synced <<< "$(python3 - <<PY
import json
with open("${MANIFEST}") as f:
    d=json.load(f).get("${id}",{})
print(d.get("commit","?"), d.get("synced_at","?"))
PY
)"
  else
    commit="?"
    synced="?"
  fi
  {
    echo "# 蒸馏 · ${id}"
    echo ""
    echo "> 自动生成自本地克隆 \`${src}\`"
    echo "> commit: \`${commit}\` · synced: ${synced}"
    echo "> 重新生成: \`bash scripts/distill-structure.sh ${id}\`"
    echo ""
    echo "## 顶层目录"
    echo "\`\`\`"
    ls -1 "${src}" 2>/dev/null | head -40
    echo "\`\`\`"
    echo ""
    echo "## 目录树（深度 3）"
    echo "\`\`\`"
    find "${src}" -maxdepth 3 -type d \
      ! -path '*/.git/*' ! -path '*/.git' \
      ! -path '*/node_modules/*' ! -path '*/vendor/*' \
      2>/dev/null | sed "s|${src}/||" | sort | head -80
    echo "\`\`\`"
    echo ""
    echo "## 关键文件采样"
    echo "\`\`\`"
    find "${src}" -maxdepth 5 -type f \( \
      -name 'pom.xml' -o -name 'go.mod' -o -name 'manage.py' -o -name 'composer.json' \
      -o -name 'package.json' -o -name '*.sln' -o -name 'main.go' \
      \) ! -path '*/.git/*' 2>/dev/null | sed "s|${src}/||" | head -20
    echo "\`\`\`"
  } > "${out}"
  echo "Wrote ${out}"
}

case "${1:-}" in
  --all|-a)
    for d in "${BASES}"/*; do
      [[ -d "${d}" ]] && distill_one "$(basename "${d}")" || true
    done
    ;;
  --help|-h|"")
    echo "Usage: $0 <base-id|--all>"
    ls -1 "${BASES}" 2>/dev/null || echo "(no bases cloned)"
    ;;
  *) distill_one "$1" ;;
esac
