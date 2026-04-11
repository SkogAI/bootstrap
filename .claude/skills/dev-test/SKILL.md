---
name: dev-test
description: Run the bootstrap dev container test and interpret the output. Use when testing changes to playbooks, roles, or bootstrap.sh before pushing.
---

# Dev Test

Run the bootstrap flow in an isolated Arch Linux container to verify changes work end-to-end.

## Prerequisites

- Changes must be pushed to GitHub before running — the container clones from GitHub, not a bind mount
- `docker` (or podman) must be running
- If a previous test left stale containers/networks, clean them up first

## Running the Test

```bash
cd dev && bash run.sh
```

This builds a bare Arch Linux container and runs `bootstrap.sh` inside it.

## Interpreting Output

**Success**: Ansible play recap shows `failed=0` and `unreachable=0`
**OOM kill**: yay AUR builds may be killed in the container (2GB limit) — this is expected and not a failure on real hardware
**Network errors**: Check for stale podman pods/networks with `podman pod ls` and `podman network ls`

## Cleanup Between Runs

```bash
# Remove stale containers and networks
podman ps -a --format "{{.Names}}" | xargs podman rm -f
podman network prune -f
```

## Common Failures

| Symptom | Cause | Fix |
|---------|-------|-----|
| `gh auth login` fails | Vault or PAT issue | Verify `pat.vault.test` with `ansible-vault view` |
| Task fails with `No such file` | Stale collections in `tmp/` | Delete `tmp/` and re-run |
| Container exits immediately | Docker daemon issue | Check `systemctl status docker` or `podman info` |
