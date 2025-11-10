#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/setup.log"
mkdir -p /var/log
exec >>"$LOG_FILE" 2>&1

# トレースはログファイルにだけ
exec 9>>"$LOG_FILE"
export BASH_XTRACEFD=9
set -x

echo "===== KillerCoda Environment Setup Start ====="
export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing prerequisites (minimal)..."
apt-get update -y -o Acquire::Retries=3
apt-get install -y --no-install-recommends curl ca-certificates git xz-utils
rm -rf /var/lib/apt/lists/*

echo ">>> Installing Node.js from official binaries..."
NODE_VERSION="20.17.0"
ARCH="x64"
NODE_PREFIX="/opt/node"
curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" -o /tmp/node.tar.xz
mkdir -p "${NODE_PREFIX}"
tar -xJf /tmp/node.tar.xz -C "${NODE_PREFIX}" --strip-components=1
rm -f /tmp/node.tar.xz
echo 'export PATH=/opt/node/bin:$PATH' >/etc/profile.d/99-node-path.sh
export PATH="/opt/node/bin:$PATH"
node -v
npm -v
corepack enable || true

echo ">>> Cloning repository..."
TMP_DIR="/tmp/kc-repo"
APP_DIR="/root/next-env-demo"
rm -rf "$TMP_DIR" "$APP_DIR" || true
git clone --depth=1 --progress https://github.com/KentaroOka-TechBase/KillaCoda-TechBase2025-Okaknt "$TMP_DIR"

echo ">>> Placing Next.js app..."
if [ -d "$TMP_DIR/scenario-nextjs-env/next-env-demo" ]; then
  mv "$TMP_DIR/scenario-nextjs-env/next-env-demo" "$APP_DIR"
elif [ -d "$TMP_DIR/next-env-demo" ]; then
  mv "$TMP_DIR/next-env-demo" "$APP_DIR"
else
  mv "$TMP_DIR" "$APP_DIR"
fi

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

# 完了フラグ＆KillerCoda通知（サーバー起動前に完了通知）
touch /root/.setup-done
echo "===== Environment setup completed successfully ====="

# Nodeを確実に使えるようパス＆リンク
cat >/etc/profile.d/99-node-path.sh <<'EOF'
export PATH="/opt/node/bin:$PATH"
EOF
chmod +x /etc/profile.d/99-node-path.sh
export PATH="/opt/node/bin:$PATH"
ln -sfn /opt/node/bin/node     /usr/local/bin/node
ln -sfn /opt/node/bin/npm      /usr/local/bin/npm
ln -sfn /opt/node/bin/npx      /usr/local/bin/npx
ln -sfn /opt/node/bin/corepack /usr/local/bin/corepack || true

echo "===== node version check ====="
node -v
echo "===== npm version check ====="
npm -v

# ===== ここからバックグラウンド起動と起動検知 =====
APP_DIR="/root/next-env-demo"
DEV_LOG="/var/log/next-dev.log"
PID_FILE="/var/run/next-dev.pid"
READY_FLAG="/opt/.appready"

echo ">>> Starting Next.js dev server in background..."
# 指示通り 'cd next-env-demo' と 'npm run dev' はオプションなし
# バックグラウンド化のために nohup と '&' を使用（npm run dev 自体にはオプションを付けていません）
cd /root
cd next-env-demo
nohup npm run dev > "$DEV_LOG" 2>&1 &

SERVER_PID=$!
mkdir -p /var/run
echo "$SERVER_PID" > "$PID_FILE"
echo ">>> Next.js dev server PID: $SERVER_PID (logs: $DEV_LOG, pid: $PID_FILE)"

# KillerCodaの「セットアップ完了」表示はすぐに出す
echo "done" > /opt/.backgroundfinished

# 起動検知（最大90秒、1秒間隔で http://localhost:3000 をポーリング）
echo ">>> Waiting for server to become ready on http://localhost:3000 ..."
READY=0
for i in $(seq 1 90); do
  if curl -fsS http://localhost:3000/ >/dev/null 2>&1; then
    READY=1
    break
  fi
  # 途中でプロセスが落ちていないか確認
  if ! kill -0 "$SERVER_PID" >/dev/null 2>&1; then
    echo "!!! Next.js dev server process exited early. See $DEV_LOG"
    break
  fi
  sleep 1
done

if [ "$READY" -eq 1 ]; then
  echo ">>> Next.js dev server is UP at http://localhost:3000"
  date +"ready at %Y-%m-%d %H:%M:%S" > "$READY_FLAG"
  echo ">>> Ready flag written to $READY_FLAG"
else
  echo "!!! Next.js dev server did not become ready within timeout."
  echo ">>> Last 50 lines of $DEV_LOG:"
  tail -n 50 "$DEV_LOG" || true
fi
