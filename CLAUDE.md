# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

One-liner bootstrap for fresh Arch Linux installs. Installs packages via pacman, decrypts a PAT with ansible-vault, authenticates gh and clones github repositories.
## Usage

See @README.md

## How it works

1. Install base deps via pacman (`github-cli uv git`)
2. Install ansible via `uv tool install ansible-core`
3. Auth gh: `ansible-vault view ./pat.vault | gh auth login --with-token`
4. Install ansible collections and run `playbooks/bootstrap.yml`

## Vault management

```bash
ansible-vault encrypt pat --output pat.vault   # encrypt plaintext PAT
ansible-vault decrypt pat.vault --output pat    # decrypt to plaintext
```
