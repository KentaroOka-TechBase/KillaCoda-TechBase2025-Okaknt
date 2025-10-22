#!/usr/bin/env bash
cat <<'EOF'
環境セットアップを開始しました。終わるまで 30〜60 秒ほどかかる場合があります。

確認コマンド:
  cd /root && ls -a

進捗:
  test -f /root/.setup-done && echo 'SETUP: done' || echo 'SETUP: running'
EOF
