# bootstrap — one-liner arch linux provisioning

<what_is_this>

fresh arch linux install → private repo access in one command and one vault password.
installs base deps, ansible, authenticates github, runs ansible playbook.

</what_is_this>

<flow>

```
bootstrap.sh
├── sudo pacman -S github-cli uv git
├── uv tool install ansible-core
├── ansible-vault view pat.vault.test | gh auth login --with-token
├── ansible-galaxy collection install -r .requirements.yml
└── ansible-playbook playbooks/bootstrap.yml
    ├── users    — wheel group, aur_builder, yay, pacman packages
    ├── packages — 53 pacman + 20 AUR packages
    ├── secrets  — SSH keys from github.com/skogai/secrets
    ├── bitwarden
    └── dolt     — dolt database + systemd service
```

</flow>

<structure>

```
bootstrap/
├── bootstrap.sh          # entry point
├── ansible.cfg            # password file paths commented out
├── .inventory             # localhost connection
├── .requirements.yml      # ansible galaxy collections
├── pat.vault              # production PAT (real vault password)
├── pat.vault.test         # test PAT (password: password1)
├── pat.password.example   # test vault password file
├── playbooks/
│   └── bootstrap.yml      # main playbook
├── roles/
│   ├── users/             # groups, aur_builder, yay, packages
│   ├── packages/          # pacman + AUR package lists
│   ├── secrets/           # SSH key cloning
│   ├── bitwarden/         # bitwarden integration
│   └── dolt/              # dolt db + systemd service
├── vars/
│   ├── main.yml           # user config (user_name: skogix)
│   └── packages.yml       # package lists
├── dev/
│   ├── Dockerfile         # bare arch container simulating archinstall
│   ├── docker-compose.yml # runs soft-serve test container
│   └── run.sh             # single entry point for dev testing
└── tmp/                   # ansible collections installed here
```

</structure>

<commands>

```bash
# run on fresh machine
git clone https://github.com/SkogAI/bootstrap.git && cd bootstrap && ./bootstrap.sh

# dev testing (from dev/)
cd dev && bash run.sh

# vault management
ansible-vault encrypt pat --output pat.vault              # encrypt PAT
ansible-vault decrypt pat.vault --output pat               # decrypt PAT
ansible-vault view pat.vault.test --vault-password-file pat.password.example  # verify test vault
```

</commands>

<gotchas>

- `ansible.cfg` password file paths are commented out — works on fresh machines without `~/.ssh/` files
- `pat.vault.test` uses password `password1` via `pat.password.example` — for container/CI only
- `uv tool install` puts binaries in `~/.local/bin` — bootstrap.sh exports PATH after install
- yay build gets OOM killed in dev container (2GB limit) — works on real hardware
- `docker` is podman on the dev host — stale pods/networks need cleanup between runs
- dev container clones from github (not bind mount) — push changes before running `dev/run.sh`

</gotchas>

<conventions>

follows @.skogai/knowledge/patterns/style/CLAUDE.md conventions.
commits: `{type}(bootstrap): {description}`

</conventions>
