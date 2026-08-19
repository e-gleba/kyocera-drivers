#!/usr/bin/env bash
set -euo pipefail

input_file="$1"
user="$2"
title="$3"
copies="$4"
options="$5"

job_name=$(echo "$title" | grep -o '[[:alnum:]]' | tr -d '\n' | tail -c 20)

arch=$(uname -m)
case "$arch" in
x86_64 | amd64)
  bin="rastertokpsl_amd64"
  ;;
i386 | i486 | i586 | i686)
  bin="rastertokpsl_x86"
  ;;
*)
  echo "[wrapper.sh] error: unsupported architecture '$arch'" >&2
  exit 1
  ;;
esac

# The real filter binary is always installed next to this wrapper.
# Resolve it relative to the script's own location so the install works
# under any prefix: /usr, /usr/local, or a --prefix override at install time.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

exec "$script_dir/$bin" "$input_file" "$user" "$job_name" "$copies" "$options"
