#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/setup.log"

# セットアップ進行状況を表示するスクリプト
# echo 文は英語化している（日本語を使うとエラーになるため）

echo "💡 Displaying setup progress (Press Ctrl+C to stop)"
echo "   Log file: $LOG_FILE"
echo

# ログファイルが作成されるまで待機
while [ ! -f "$LOG_FILE" ]; do
  echo "(Waiting for setup process to start...)"
  sleep 1
done

# ログをリアルタイム表示しながら、完了フラグを監視
tail -n +1 -f "$LOG_FILE" &
TAIL_PID=$!

# セットアップ完了フラグを待つ
while [ ! -f /root/.setup-done ]; do
  sleep 1
done

# tail を停止
kill "$TAIL_PID" || true

echo
echo "✅ Setup completed successfully!"
echo "You can now run: cd /root/next-env-demo && npm run dev"
