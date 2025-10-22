#!/bin/bash
set -euxo pipefail

echo "===== 環境初期化開始 ====="
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y curl git nodejs npm

echo "===== GitHubからクローン中 ====="
TMP_DIR="/tmp/kc-repo"
rm -rf "$TMP_DIR" /root/next-env-demo || true
git clone --depth=1 https://github.com/KentaroOka-TechBase/KillaCoda-TechBase2025-Okaknt "$TMP_DIR"

echo "===== Next.jsアプリの配置 ====="
# 1) 最優先: scenario-nextjs-env/next-env-demo がある場合
if [ -d "$TMP_DIR/scenario-nextjs-env/next-env-demo" ]; then
  mv "$TMP_DIR/scenario-nextjs-env/next-env-demo" /root/next-env-demo
# 2) 次善: 直下に next-env-demo がある場合
elif [ -d "$TMP_DIR/next-env-demo" ]; then
  mv "$TMP_DIR/next-env-demo" /root/next-env-demo
# 3) フォールバック: リポジトリ直下を全部置く（最終手段）
else
  mv "$TMP_DIR" /root/next-env-demo
fi

echo "===== 依存インストール（package.json がある場合のみ） ====="
if [ -f /root/next-env-demo/package.json ]; then
  cd /root/next-env-demo
  npm install
fi

touch /root/.setup-done
echo "===== 初期化完了 ====="
