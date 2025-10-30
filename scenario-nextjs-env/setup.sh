#!/bin/bash
set -euxo pipefail

# === ログ設定 ===
LOG_FILE="/var/log/setup.log"
mkdir -p /var/log
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== KillerCoda Environment Setup Start ====="
export DEBIAN_FRONTEND=noninteractive

# === APT: 最小限だけ（高速化の要） ===
echo ">>> Installing prerequisites (minimal)..."
apt-get update -y -o Acquire::Retries=3
apt-get install -y --no-install-recommends curl ca-certificates git xz-utils
rm -rf /var/lib/apt/lists/*

# === Node.js: 公式バイナリを展開（依存ほぼゼロで一瞬） ===
echo ">>> Installing Node.js from official binaries..."
NODE_VERSION="20.17.0"            # LTS系に合わせて必要なら更新
ARCH="x64"                         # KillerCodaはx86_64
NODE_PREFIX="/opt/node"
curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" -o /tmp/node.tar.xz
mkdir -p "${NODE_PREFIX}"
tar -xJf /tmp/node.tar.xz -C "${NODE_PREFIX}" --strip-components=1
rm -f /tmp/node.tar.xz
# PATH 永続化
echo 'export PATH=/opt/node/bin:$PATH' >/etc/profile.d/99-node-path.sh
export PATH="/opt/node/bin:$PATH"
node -v
npm -v
corepack enable || true   # 将来pnpm/yarnを使う場合の準備

# === GitHubから教材を取得 ===
echo ">>> Cloning repository..."
TMP_DIR="/tmp/kc-repo"
APP_DIR="/root/next-env-demo"
rm -rf "$TMP_DIR" "$APP_DIR" || true
git clone --depth=1 --progress \
  https://github.com/KentaroOka-TechBase/KillaCoda-TechBase2025-Okaknt "$TMP_DIR"

echo ">>> Placing Next.js app..."
if [ -d "$TMP_DIR/scenario-nextjs-env/next-env-demo" ]; then
  mv "$TMP_DIR/scenario-nextjs-env/next-env-demo" "$APP_DIR"
elif [ -d "$TMP_DIR/next-env-demo" ]; then
  mv "$TMP_DIR/next-env-demo" "$APP_DIR"
else
  mv "$TMP_DIR" "$APP_DIR"
fi

# === node_modules を Release から取得（最速ルート） ===
echo ">>> Downloading prebuilt node_modules..."
ASSET_URL="https://github.com/KentaroOka-TechBase/KillaCoda-TechBase2025-Okaknt/releases/download/v1.0.0/node_modules.tar.gz"
MAX_RETRIES=5
for i in $(seq 1 $MAX_RETRIES); do
  if curl -L --fail -o "$APP_DIR/node_modules.tar.gz" "$ASSET_URL"; then
    echo ">>> node_modules.tar.gz downloaded."
    break
  else
    echo ">>> Download failed (try $i/$MAX_RETRIES), retrying in 3s..."
    sleep 3
  fi
done

echo ">>> Preparing dependencies..."
cd "$APP_DIR"
if [ -f "$APP_DIR/node_modules.tar.gz" ]; then
  rm -rf node_modules || true
  tar -xzf "$APP_DIR/node_modules.tar.gz" -C "$APP_DIR"
  echo ">>> node_modules extracted."
else
  echo "!!! Tarball missing; fallback to npm ci/install (this is slower)"
  if [ -f package-lock.json ]; then
    npm ci --no-audit --no-fund --prefer-offline
  else
    npm install --no-audit --no-fund
  fi
fi

# === 完了 ===
touch /root/.setup-done
echo "===== Environment setup completed successfully ====="
echo "done" > /opt/.backgroundfinished

# Node.js 展開済み（/opt/node に入っている前提）
NODE_PREFIX="/opt/node"

# 1) 永続的 PATH 追加（次回以降のシェルにも反映）
cat >/etc/profile.d/99-node-path.sh <<'EOF'
export PATH="/opt/node/bin:$PATH"
EOF
chmod +x /etc/profile.d/99-node-path.sh

# 2) いま開いているシェル向けに即時 PATH 反映
export PATH="/opt/node/bin:$PATH"

# 3) 端末の種類に関係なく使えるよう、共通の場所にシンボリックリンク
ln -sfn /opt/node/bin/node     /usr/local/bin/node
ln -sfn /opt/node/bin/npm      /usr/local/bin/npm
ln -sfn /opt/node/bin/npx      /usr/local/bin/npx
ln -sfn /opt/node/bin/corepack /usr/local/bin/corepack || true

# sanity check
echo "===== node version check ====="
node -v


echo "===== npm version check ====="
npm -v
