

#!/usr/bin/env bash
set -euo pipefail

cd /Users/umu/Documents/code-repo/ai-repo

clone_cmds=()
dirty_repos=()
no_origin_repos=()

for d in */; do
  [ -d "$d" ] || continue
  cd "$d"

  if [ -d .git ]; then
    repo_name="$(basename "$PWD")"

    # 1. 记录是否有未提交
    if [ -n "$(git status --porcelain)" ]; then
      dirty_repos+=("$repo_name")
    fi

    # 2. 获取 origin 地址，生成 clone 命令
    if remote_url=$(git remote get-url origin 2>/dev/null); then
      clone_cmds+=("git clone $remote_url")
    else
      no_origin_repos+=("$repo_name")
    fi
  fi

  cd ..
done

echo "==== 所有可用的 clone 命令 ===="
if [ ${#clone_cmds[@]} -eq 0 ]; then
  echo "无（没有设置 origin 的仓库）"
else
  for cmd in "${clone_cmds[@]}"; do
    echo "$cmd"
  done
fi

echo
echo "==== 有未提交改动的仓库 ===="
if [ ${#dirty_repos[@]} -eq 0 ]; then
  echo "无（全部干净）"
else
  for name in "${dirty_repos[@]}"; do
    echo "$name"
  done
fi

echo
echo "==== 没有设置 origin 的仓库（无法自动生成 clone 命令） ===="
if [ ${#no_origin_repos[@]} -eq 0 ]; then
  echo "无"
else
  for name in "${no_origin_repos[@]}"; do
    echo "$name"
  done
fi

