#!/bin/sh
# Install a standalone CLI application outside the Jenkins workspace.
set -eu
: "${DEPLOY_DIR:?Set DEPLOY_DIR to an absolute directory outside the workspace}"
: "${PYTHON_BIN:=python3}"
case "$DEPLOY_DIR" in
    /*) ;;
    *) echo 'DEPLOY_DIR must be absolute' >&2; exit 1 ;;
esac
mkdir -p "$DEPLOY_DIR"
deploy_path=$(cd "$DEPLOY_DIR" && pwd -P)
source_path=$(pwd -P)
case "$deploy_path/" in
    "$source_path/"*) echo 'Deployment must be outside the workspace' >&2; exit 1 ;;
esac
# Copy to a temporary file in the destination; rename publishes atomically.
staged=$(mktemp "$deploy_path/.app.XXXXXX")
trap 'rm -f "$staged"' EXIT HUP INT TERM
cp app.py "$staged"
chmod 644 "$staged"
mv "$staged" "$deploy_path/app.py"
actual=$("$PYTHON_BIN" "$deploy_path/app.py")
expected='Hello, World from Anthony John Kanaan!'
if [ "$actual" != "$expected" ]; then
    echo "Smoke check failed: $actual" >&2
    exit 1
fi
printf 'Deployed to %s/app.py\nSmoke check passed: %s\n' "$deploy_path" "$actual"
