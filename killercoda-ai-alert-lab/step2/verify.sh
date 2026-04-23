#!/bin/bash
set -euo pipefail

chmod +x /root/lab/lab-files/check_alert.sh
cd /root/lab/lab-files

real_output="$(docker exec ai-alert-monitor sh -lc 'cd /lab && sh ./check_alert.sh sample_logs/real_incident.log')"
noise_output="$(docker exec ai-alert-monitor sh -lc 'cd /lab && sh ./check_alert.sh sample_logs/noise.log')"

echo "$real_output" | grep -q "ALERT"
echo "$noise_output" | grep -q "OK"

echo "Verification passed."
