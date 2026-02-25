#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm github-cli uv ansible-core chezmoi git
uv venv --seed --clear
source .venv/bin/activate
uv tool install ansible-core

ansible-vault view ./pat.vault | gh auth login --with-token
ansible-galaxy collection install --requirements-file=.requirements.yml --force
ansible-playbook playbooks/bootstrap.yml --ask-become-pass
