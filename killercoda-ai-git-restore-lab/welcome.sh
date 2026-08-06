#!/bin/bash

READY_FLAG="/root/.git-restore-setup-done"

echo "Preparing the lab environment..."
while [ ! -f "$READY_FLAG" ]; do
  sleep 1
done

echo
echo "Lab setup completed."
echo "Move to the workspace and start the exercise:"
echo "cd /root/lab/workspace"