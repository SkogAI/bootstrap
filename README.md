# bootstrap

One-liner bootstrap for fresh Arch Linux installs. Goes from archinstall to private repo access with a single command and one vault password.

## Usage

```bash
curl -fsSL https://raw.githubusercontent.com/SkogAI/bootstrap/master/bootstrap.sh | bash
```

### What it does

1. **Foundation** — system upgrade, installs git, base-devel, openssh, github-cli, ansible-core, yay
2. **Secret Unlock** — clones this repo, decrypts `secrets.vault` (one password prompt)
3. **Identity** — deploys SSH keys, sets git config, authenticates `gh`, verifies access

### Dry run

Preview what would happen without making changes:

```bash
curl -fsSL https://raw.githubusercontent.com/SkogAI/bootstrap/master/bootstrap.sh | DRY_RUN=true bash
```

### Headless / CI

```bash
SKOGAI_BECOME_PASSWORD="mypassword" bash bootstrap.sh
```

## Vault management

The `secrets.vault` file is an ansible-vault encrypted tar.gz containing SSH keys, a GitHub PAT, and git identity.

```bash
make help       # show all targets
make decrypt    # vault → secrets/ dir
make encrypt    # secrets/ dir → vault
make edit       # decrypt, open shell, re-encrypt on exit
make verify     # test vault can be decrypted
make lint       # shellcheck bootstrap.sh
make clean      # shred plaintext files
```

### Vault contents

```
secrets/
├── ssh/
│   ├── id_ed25519
│   ├── id_ed25519.pub
│   └── config          # optional
├── github_pat           # single line: ghp_...
└── gitconfig            # name=skogix\nemail=...
```

### Creating the vault from scratch

```bash
mkdir -p secrets/ssh
cp ~/.ssh/id_ed25519 secrets/ssh/
cp ~/.ssh/id_ed25519.pub secrets/ssh/
echo "ghp_yourtoken" > secrets/github_pat
printf 'name=skogix\nemail=your@email.com\n' > secrets/gitconfig
make encrypt
```

## Safety

- Idempotent: safe to run multiple times
- Cleanup trap: shreds temp files on exit/interrupt
- Arch-only: exits on non-Arch systems
- Non-root: refuses to run as root
- `--needed` flag: skips already-installed packages
- btrfs note: `shred` is ineffective on CoW filesystems
