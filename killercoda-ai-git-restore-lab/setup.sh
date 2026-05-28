#!/bin/bash
set -euo pipefail

WORKROOT="/root/lab"
WORKDIR="$WORKROOT/workspace"

if ! command -v git >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y git
fi

rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

cat > "$WORKDIR/app.py" <<'EOF'
def main():
    print("Hello from the demo app.")


if __name__ == "__main__":
    main()
EOF

cat > "$WORKDIR/README.md" <<'EOF'
# Demo App

This small project is used to practice restoring a workspace after Git metadata was moved aside.
EOF

cat > "$WORKDIR/AI_SAFETY_NOTE.md" <<'EOF'
# AI Safety Note

An AI-assisted safety action was triggered during a workspace edit session.
The repository metadata was moved from `.git` to `.git_disabled` to prevent further changes.
EOF

cd "$WORKDIR"
git init -q
git config user.name "KillerCoda"
git config user.email "killercoda@example.com"
git add .
git commit -m "Initial commit" >/dev/null 2>&1
mv .git .git_disabled

echo "Workspace prepared at $WORKDIR"
