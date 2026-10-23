#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
command -v terraform >/dev/null || { echo "terraform is required" >&2; exit 1; }
command -v ansible-playbook >/dev/null || { echo "ansible-playbook is required" >&2; exit 1; }
terraform -chdir="$ROOT/terraform" fmt -check -recursive
terraform -chdir="$ROOT/terraform" init -backend=false
terraform -chdir="$ROOT/terraform" validate
for play in install-pinned backup upgrade verify; do
  ansible-playbook -i "$ROOT/ansible/inventory/example.ini" "$ROOT/ansible/playbooks/${play}.yml" --syntax-check
done
echo "Static checks passed. No AWS deployment was performed."
