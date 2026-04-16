#!/bin/bash
set -euo pipefail

mkdir -p /root/lab
rm -rf /root/lab/lab-files
cp -R ./lab-files /root/lab/

cd /root/lab/lab-files
chmod +x check_alert.sh
docker compose up -d

echo "Environment is ready under /root/lab/lab-files"
