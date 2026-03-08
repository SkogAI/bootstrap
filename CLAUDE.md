# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

One-liner bootstrap for fresh Arch Linux installs. Installs packages via pacman, decrypts a PAT with ansible-vault, authenticates gh and clones github repositories.

## Usage

See @README.md

## How it works

1. Install base deps via pacman (`github-cli uv git`)
2. Install ansible via `uv tool install ansible-core` + export PATH
3. Auth gh: `ANSIBLE_VAULT_PASSWORD_FILE=./pat.password.example ansible-vault view ./pat.vault.test | gh auth login --with-token`
4. Install ansible collections and run `playbooks/bootstrap.yml`

## Testing

- `pat.vault.test` encrypted with `password1` (via `pat.password.example`) for container/CI use
- `pat.vault` uses production vault password for real deployments
- ansible.cfg password file paths are commented out — works on fresh machines without `~/.ssh/` files
- tested via `projects/headquarters/run.sh` which builds a bare arch container and runs bootstrap

## Vault management

```bash
ansible-vault encrypt pat --output pat.vault   # encrypt plaintext PAT
ansible-vault decrypt pat.vault --output pat    # decrypt to plaintext
```
