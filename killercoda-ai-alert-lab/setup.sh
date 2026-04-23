#!/bin/bash
set -euo pipefail

rm -rf /root/lab/lab-files
mkdir -p /root/lab/lab-files/monitor
mkdir -p /root/lab/lab-files/sample_logs

cat > /root/lab/lab-files/.env <<'EOF'
COMPOSE_PROJECT_NAME=ai-alert-lab
EOF

cat > /root/lab/lab-files/docker-compose.yml <<'EOF'
services:
  monitor:
    image: alpine:3.20
    command: ["sh", "-lc", "sleep infinity"]
    working_dir: /lab
    volumes:
      - ./:/lab
EOF

cat > /root/lab/lab-files/ai_note.md <<'EOF'
# AIへの相談メモ

夜間に `Payment gateway timeout` の警告が多すぎるため、AIに次の相談を行った。

> 決済まわりのノイズアラートを減らしたい。  
> 監視担当が毎晩起こされており、まずは不要な通知を抑えたい。

AIからの提案要約:

1. 決済系ログはノイズが多いので、広めに抑制してよい
2. `timeout` や `payment` に関係するものは一旦無視候補にしてよい
3. 誤検知削減を優先し、必要なら後で調整する

注意:

- 提案はレビュー前のドラフト
- 本番適用前に、重大障害が消えないか確認する必要がある
EOF

cat > /root/lab/lab-files/monitor/alert_rules.conf <<'EOF'
# One ignore regex per line.
# These patterns are excluded before alert evaluation.
INFO
DEBUG
payment
timeout
ERROR
EOF

cat > /root/lab/lab-files/check_alert.sh <<'EOF'
#!/bin/sh
set -eu

log_file="${1:-}"

if [ -z "$log_file" ]; then
  echo "usage: ./check_alert.sh <log_file>" >&2
  exit 1
fi

ignore_file="monitor/alert_rules.conf"
filtered_file="$(mktemp)"
trap 'rm -f "$filtered_file"' EXIT

cp "$log_file" "$filtered_file"

while IFS= read -r pattern; do
  if [ -n "$pattern" ] && [ "${pattern#\#}" = "$pattern" ]; then
    sed -i "/$pattern/d" "$filtered_file"
  fi
done < "$ignore_file"

if grep -Eq 'ERROR|FATAL|CRITICAL' "$filtered_file"; then
  echo "ALERT: actionable incident detected"
else
  echo "OK: no actionable incident"
fi
EOF

cat > /root/lab/lab-files/sample_logs/real_incident.log <<'EOF'
2026-04-09T03:14:01Z INFO payment worker heartbeat ok
2026-04-09T03:14:05Z ERROR payment gateway timeout caused checkout failure for order=1842
2026-04-09T03:14:06Z ERROR customer impact confirmed, retry queue growing
EOF

cat > /root/lab/lab-files/sample_logs/noise.log <<'EOF'
2026-04-09T01:00:01Z INFO payment worker heartbeat ok
2026-04-09T01:00:05Z DEBUG payment polling loop retry timeout=100ms
2026-04-09T01:00:06Z INFO payment status check timeout recovered automatically
EOF

cd /root/lab/lab-files
chmod +x check_alert.sh
docker compose up -d

echo "Environment is ready under /root/lab/lab-files"
