#!/bin/bash
set -euxo pipefail

# すべての標準出力/標準エラーをログへ
LOG_FILE="/var/log/setup.log"
mkdir -p /var/log
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== initialize ====="
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y curl git nodejs npm

echo "===== clone from GitHub ====="
TMP_DIR="/tmp/kc-repo"
APP_DIR="/root/next-env-demo"
rm -rf "$TMP_DIR" "$APP_DIR" || true
git clone --depth=1 --progress \
  https://github.com/KentaroOka-TechBase/KillaCoda-TechBase2025-Okaknt "$TMP_DIR"

echo "===== Next.js Application Setting ====="
# リポジトリ内のアプリ配置（両パターン対応）
if [ -d "$TMP_DIR/scenario-nextjs-env/next-env-demo" ]; then
  mv "$TMP_DIR/scenario-nextjs-env/next-env-demo" "$APP_DIR"
elif [ -d "$TMP_DIR/next-env-demo" ]; then
  mv "$TMP_DIR/next-env-demo" "$APP_DIR"
else
  mv "$TMP_DIR" "$APP_DIR"
fi

# tarball の候補（どちらかに置いてあればOK）
TARBALL_A="$APP_DIR/node_modules.tar.gz"
TARBALL_B="$APP_DIR/../node_modules.tar.gz"   # 例: scenario-nextjs-env/node_modules.tar.gz

echo "===== wait 5 seconds before install/extract ====="
sleep 5

echo "===== dependency prepare ====="
cd "$APP_DIR"

# 1) node_modules.tar.gz があれば最速パス：展開して完了
if [ -f "$TARBALL_A" ] || [ -f "$TARBALL_B" ]; then
  TARBALL="${TARBALL_A}"
  [ -f "$TARBALL_B" ] && TARBALL="${TARBALL_B}"

  echo ">>> Found tarball: $TARBALL"
  echo ">>> Extracting node_modules (this is fast)..."
  # 既存があれば消す
  rm -rf node_modules || true
  tar -xzf "$TARBALL" -C "$APP_DIR"

  # ネイティブモジュールが含まれている可能性に軽く対応（無ければ一瞬で終わる）
  # 重くしたくないので rebuild は任意。必要ならコメントアウトを外してください。
  # npm rebuild --silent || true

  echo ">>> node_modules extracted."
else
  # 2) tarball がない場合のフォールバック：npm ci（早めのフラグで体感改善）
  echo ">>> tarball not found. Running npm ci (fallback)..."
  npm config set progress true
  # lockfile がある前提なら ci が高速・安定
  if [ -f package-lock.json ]; then
    npm ci --loglevel=notice --no-audit --no-fund
  else
    npm install --loglevel=notice --no-audit --no-fund
  fi
fi

touch /root/.setup-done
echo "===== initialize Done ====="

# KillerCoda に「準備完了」を通知
echo "done" > /opt/.backgroundfinished
