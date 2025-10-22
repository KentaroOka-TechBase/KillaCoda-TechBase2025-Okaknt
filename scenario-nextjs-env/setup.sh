#!/usr/bin/env bash
set -euxo pipefail
echo "===== 環境初期化開始 ====="
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y curl git nodejs npm

echo "===== GitHubからクローン中 ====="
rm -rf /root/next-env-demo || true
git clone https://github.com/KentaroOka-TechBase/KillaCoda-TechBase2025-Okaknt /root/next-env-demo

if [ -f /root/next-env-demo/package.json ]; then
  echo "===== npm install 実行 ====="
  cd /root/next-env-demo
  npm install
fi

touch /root/.setup-done
echo "===== 初期化完了 ====="
