#!/usr/bin/env bash
set -euxo pipefail

echo "===== 環境初期化開始 ====="
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y curl git nodejs npm

echo "===== GitHubからクローン中 ====="
rm -rf /root/next-env-demo || true
git clone https://github.com/KentaroOka-TechBase/KillaCoda-TechBase2025-Okaknt /root/next-env-demo

echo "===== 依存インストール（package.jsonがある場合） ====="
if [ -f /root/next-env-demo/package.json ]; then
  cd /root/next-env-demo
  npm install
fi

echo "===== 初期化完了 ====="
