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
