---
name: vault-ops
description: Reference for Ansible Vault operations in this repo — encrypt, decrypt, view, and verify PAT vaults. Use when working with pat.vault or pat.vault.test.
---

# Vault Operations

## Vault Files in This Repo

| File | Purpose | Password |
|------|---------|---------|
| `pat.vault` | Production PAT for real GitHub auth | Real vault password (not stored here) |
| `pat.vault.test` | Test PAT for container/CI | `password1` (via `pat.password.example`) |
| `pat.password.example` | Password file for test vault | Contains `password1` |

**Never commit the unencrypted `pat` file.** It is in `.gitignore`.

## Common Commands

```bash
# View test vault (no real password needed)
ansible-vault view pat.vault.test --vault-password-file pat.password.example

# Encrypt a new PAT into the test vault
ansible-vault encrypt pat --output pat.vault.test --vault-password-file pat.password.example

# Encrypt a new PAT into the production vault (prompts for password)
ansible-vault encrypt pat --output pat.vault

# Decrypt production vault to a file (careful — unencrypted)
ansible-vault decrypt pat.vault --output pat

# Re-key (change password on) a vault file
ansible-vault rekey pat.vault
```

## Verifying the Test Vault Works

```bash
ansible-vault view pat.vault.test --vault-password-file pat.password.example
# Should print the GitHub PAT token
```

## Notes

- `ansible.cfg` has vault password file paths commented out — this is intentional for fresh machines
- In `bootstrap.sh`, the vault is decrypted inline: `ansible-vault view pat.vault | gh auth login --with-token`
- For dev/CI testing, always use `pat.vault.test` with `pat.password.example`
