#!/bin/bash
set -euo pipefail

cd /root/lab/lab-files

real_output="$(docker compose exec -T monitor sh -lc 'cd /lab && sh ./check_alert.sh sample_logs/real_incident.log')"
noise_output="$(docker compose exec -T monitor sh -lc 'cd /lab && sh ./check_alert.sh sample_logs/noise.log')"

echo "$real_output" | grep -q "ALERT"
echo "$noise_output" | grep -q "OK"

echo "Verification passed."
