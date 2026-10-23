# Contributing

1. Open an issue describing the proposed change and its operational impact.
2. Keep Terraform inputs variable-driven and never commit state, credentials or private keys.
3. Use idempotent Ansible modules where possible; document any unavoidable command usage.
4. Update the README, runbook and website when behavior changes.
5. Run `terraform fmt -recursive`, `terraform validate`, YAML lint and Ansible syntax checks.
6. Test upgrades and backup restoration in a disposable environment before claiming operational readiness.
7. Use concise commits that describe the actual change.

Do not use this repository to upgrade a production Jenkins controller without an approved change plan, tested backup, compatibility review and rollback strategy.
