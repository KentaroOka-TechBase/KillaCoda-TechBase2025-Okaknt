#!/bin/bash
set -euxo pipefail

# === ログ設定 ===
LOG_FILE="/var/log/setup.log"
mkdir -p /var/log
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== KillerCoda Environment Setup Start ====="

export DEBIAN_FRONTEND=noninteractive

# === 基本ツールのインストール ===
echo ">>> Installing prerequisites..."
apt update -y
apt install -y curl git nodejs npm

# === GitHubリポジトリからクローン ===
echo ">>> Cloning repository..."
TMP_DIR="/tmp/kc-repo"
APP_DIR="/root/next-env-demo"

rm -rf "$TMP_DIR" "$APP_DIR" || true

# 進捗表示を有効 (--progress)
git clone --depth=1 --progress \
  https://github.com/KentaroOka-TechBase/KillaCoda-TechBase2025-Okaknt "$TMP_DIR"

# === Next.js アプリ配置 ===
echo ">>> Setting up Next.js application..."
if [ -d "$TMP_DIR/scenario-nextjs-env/next-env-demo" ]; then
  mv "$TMP_DIR/scenario-nextjs-env/next-env-demo" "$APP_DIR"
elif [ -d "$TMP_DIR/next-env-demo" ]; then
  mv "$TMP_DIR/next-env-demo" "$APP_DIR"
else
  mv "$TMP_DIR" "$APP_DIR"
fi

# === node_modules をReleaseから取得 ===
echo ">>> Downloading prebuilt node_modules..."
ASSET_URL="https://github.com/KentaroOka-TechBase/KillaCoda-TechBase2025-Okaknt/releases/download/v1.0.0/node_modules.tar.gz"

# 再試行付きダウンロード（失敗時リトライ）
MAX_RETRIES=5
for i in $(seq 1 $MAX_RETRIES); do
  if curl -L --fail -o "$APP_DIR/node_modules.tar.gz" "$ASSET_URL"; then
    echo ">>> node_modules.tar.gz downloaded successfully."
    break
  else
    echo ">>> Download failed (try $i/$MAX_RETRIES), retrying in 5s..."
    sleep 5
  fi
done

# === 展開 ===
if [ -f "$APP_DIR/node_modules.tar.gz" ]; then
  echo ">>> Extracting node_modules..."
  rm -rf "$APP_DIR/node_modules" || true
  tar -xzf "$APP_DIR/node_modules.tar.gz" -C "$APP_DIR"
  echo ">>> node_modules extracted successfully."
else
  echo "!!! node_modules.tar.gz not found, fallback to npm install..."
  cd "$APP_DIR"
  npm ci --no-audit --no-fund --prefer-offline || npm install --no-audit --no-fund
fi

# === ビルドテスト（任意、確認用）===
if [ -f "$APP_DIR/package.json" ]; then
  echo ">>> Checking package.json presence... OK"
else
  echo "!!! Warning: package.json not found at $APP_DIR"
fi

# === 完了処理 ===
touch /root/.setup-done
echo "===== Environment setup completed successfully ====="

# === KillerCoda に完了通知 ===
echo "done" > /opt/.backgroundfinished
