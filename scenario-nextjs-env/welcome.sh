#!/usr/bin/env bash
cat <<'EOF'
The environment setup has begun. This may take approximately 1 minute to complete.

check command:
  cd /root && ls -a

progress:
  test -f /root/.setup-done && echo 'SETUP: done' || echo 'SETUP: running'
EOF
