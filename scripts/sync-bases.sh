#!/usr/bin/env bash
# Sync open-source admin bases into references/bases/
# macOS compatible (no bash 4 associative arrays)
# Usage: sync-bases.sh <base-id|--all|--list>
set -eo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REF_DIR="${SKILL_DIR}/references/bases"
MANIFEST="${SKILL_DIR}/references/manifest.json"

BASE_IDS=(
  ruoyi ruoyi-cloud ruoyi-react ruoyi-activiti ruoyi-process
  django-vue-admin yisha yi-netcore gfast yjgo b5-laravel
)

base_url() {
  case "$1" in
    ruoyi)             echo "https://gitee.com/y_project/RuoYi.git" ;;
    ruoyi-cloud)       echo "https://gitee.com/y_project/RuoYi-Cloud.git" ;;
    ruoyi-react)       echo "https://gitee.com/whiteshader/ruoyi-react.git" ;;
    ruoyi-activiti)    echo "https://gitee.com/smell2/ruoyi-vue-activiti.git" ;;
    ruoyi-process)     echo "https://gitee.com/calvinhwang123/RuoYi-Process.git" ;;
    django-vue-admin)  echo "https://gitee.com/liqianglog/django-vue-admin.git" ;;
    yisha)             echo "https://gitee.com/liukuo362573/YiShaAdmin.git" ;;
    yi-netcore)        echo "https://gitee.com/ccnetcore/yi.git" ;;
    gfast)             echo "https://gitee.com/tiger1103/gfast.git" ;;
    yjgo)              echo "https://github.com/guolingege/yjgo.git" ;;
    b5-laravel)        echo "https://gitee.com/b5net/b5-laravel-cmf.git" ;;
    *)                 return 1 ;;
  esac
}

list_bases() {
  echo "Available base-id:"
  for id in "${BASE_IDS[@]}"; do
    echo "  ${id} -> $(base_url "${id}")"
  done
}

mkdir -p "${REF_DIR}"
mkdir -p "$(dirname "${MANIFEST}")"

sync_one() {
  local id="$1"
  local url
  url="$(base_url "${id}")" || { echo "Unknown base-id: ${id}" >&2; list_bases; exit 1; }
  local dest="${REF_DIR}/${id}"
  if [[ -d "${dest}/.git" ]]; then
    echo "==> Pull ${id} ..."
    git -C "${dest}" pull --ff-only 2>/dev/null || {
      git -C "${dest}" fetch --depth 1 origin
      git -C "${dest}" reset --hard FETCH_HEAD 2>/dev/null || git -C "${dest}" reset --hard origin/master 2>/dev/null || true
    }
  else
    echo "==> Clone ${id} (shallow) ..."
    rm -rf "${dest}"
    git clone --depth 1 "${url}" "${dest}" || {
      echo "FAILED clone ${id} from ${url}" >&2
      return 1
    }
  fi
  local commit now
  commit="$(git -C "${dest}" rev-parse --short HEAD 2>/dev/null || echo unknown)"
  now="$(date -Iseconds 2>/dev/null || date)"
  echo "    ${id} @ ${commit} @ ${now}"
  if command -v python3 >/dev/null 2>&1; then
    python3 - <<PY
import json, os
path = "${MANIFEST}"
data = {}
if os.path.isfile(path):
    with open(path) as f:
        data = json.load(f)
data["${id}"] = {"url": "${url}", "commit": "${commit}", "synced_at": "${now}", "path": "${dest}"}
with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
PY
  fi
}

case "${1:-}" in
  --list|-l) list_bases ;;
  --all|-a)
    for id in "${BASE_IDS[@]}"; do
      sync_one "${id}" || echo "WARN: failed ${id}" >&2
    done
    echo "Done. Manifest: ${MANIFEST}"
    ;;
  --help|-h|"")
    echo "Usage: $0 <base-id|--all|--list>"
    list_bases
    ;;
  *) sync_one "$1"; echo "Done. Path: ${REF_DIR}/$1" ;;
esac
