#!/bin/bash
set -euxo pipefail

# すべての標準出力/標準エラーをログへ
LOG_FILE="/var/log/setup.log"
mkdir -p /var/log
# 両方 tee しつつログ保存（ターミナル側からも読める）
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===== initialize ====="
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y curl git nodejs npm

echo "===== clone from GitHub ====="
TMP_DIR="/tmp/kc-repo"
rm -rf "$TMP_DIR" /root/next-env-demo || true
# 非TTYでも進捗を出すために --progress を明示（gitはstderrに進捗を出す）
git -c progress=true clone --depth=1 --progress \
  https://github.com/KentaroOka-TechBase/KillaCoda-TechBase2025-Okaknt "$TMP_DIR"

echo "===== Next.js Application Setting ====="
if [ -d "$TMP_DIR/scenario-nextjs-env/next-env-demo" ]; then
  mv "$TMP_DIR/scenario-nextjs-env/next-env-demo" /root/next-env-demo
elif [ -d "$TMP_DIR/next-env-demo" ]; then
  mv "$TMP_DIR/next-env-demo" /root/next-env-demo
else
  mv "$TMP_DIR" /root/next-env-demo
fi

# ← ここで 5 秒だけ待ってから npm を実行
echo "===== wait 5 seconds before npm install ====="
sleep 5

echo "===== install Dependency Packages ====="
if [ -f /root/next-env-demo/package.json ]; then
  cd /root/next-env-demo
  # 非TTYでも経過が出るよう notice レベル、進捗ON
  npm config set progress true
  npm install --loglevel=notice
fi

touch /root/.setup-done
echo "===== initialize Done ====="

# Killercoda に「準備完了」を通知
echo "done" > /opt/.backgroundfinished
