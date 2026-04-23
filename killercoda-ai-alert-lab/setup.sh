#!/bin/bash
set -euo pipefail

mkdir -p /root/lab
cd /root/lab/lab-files
chmod +x check_alert.sh
docker compose up -d

echo "Environment is ready under /root/lab/lab-files"
