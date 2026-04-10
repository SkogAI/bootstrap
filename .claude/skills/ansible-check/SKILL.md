---
name: ansible-check
description: Run syntax check and ansible-lint on changed playbooks and roles. Use before committing Ansible changes to catch errors early.
---

# Ansible Check

Validate Ansible playbooks and roles before committing.

## Syntax Check (always available)

```bash
# Check main playbook syntax
ansible-playbook playbooks/bootstrap.yml --syntax-check -i .inventory

# Check a specific role's tasks
ansible-playbook playbooks/bootstrap.yml --syntax-check -i .inventory --tags ROLE_NAME
```

## Lint (if ansible-lint is installed)

```bash
# Install ansible-lint if missing
pip install ansible-lint
# or
uv tool install ansible-lint

# Lint the main playbook
ansible-lint playbooks/bootstrap.yml

# Lint a specific role
ansible-lint roles/ROLE_NAME/
```

## Dry Run (check mode)

```bash
# See what would change without applying
ansible-playbook playbooks/bootstrap.yml --check -i .inventory
```

## What to Check After Editing

| Changed | Command |
|---------|---------|
| `playbooks/bootstrap.yml` | `ansible-playbook playbooks/bootstrap.yml --syntax-check -i .inventory` |
| `roles/*/tasks/*.yml` | `ansible-playbook playbooks/bootstrap.yml --syntax-check -i .inventory` |
| `vars/*.yml` | Verify YAML syntax is valid (yamllint if available) |
| `bootstrap.sh` | `bash -n bootstrap.sh` (syntax check only) |

## Notes

- Collections must be installed (`ansible-galaxy collection install -r .requirements.yml`) before syntax-check works
- Collections install to `./tmp/collections/` (set in `ansible.cfg`)
- If collections are missing: `cd /home/skogix/bootstrap && ansible-galaxy collection install -r .requirements.yml`
