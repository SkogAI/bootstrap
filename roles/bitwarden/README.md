# Bitwarden CLI Setup Guide

This bootstrap installs and configures Bitwarden tools for CLI password management:

## Components

### 1. **rbw** (Rust Bitwarden)
- Lightweight CLI client for Bitwarden
- Provides secure password retrieval from the command line
- Handles local caching and encryption
- **Note**: This is a CLI tool, not a daemon service

### 2. **rbw-rofi** 
- Integrates rbw with rofi (a window switcher/dmenu replacement)
- Provides a searchable GUI for password selection
- Automatically copies selected passwords to clipboard

### 3. **bitwarden-systemd** (optional, systemd-bw)
- Optional systemd user service wrapper for rbw
- Automatically started with your session
- Provides better integration with desktop environments

## Configuration

The bootstrap automatically creates the required configuration files:

### rbw Config
Location: `~/.config/rbw/config.toml`
```toml
base_url = "https://vault.bitwarden.com"
identity_url = "https://identity.bitwarden.com"
lock_timeout = 3600
sync_interval = 3600
```

**Important**: Your email is NOT pre-configured. You must add it by running `rbw login`.

## Initial Setup (REQUIRED AFTER BOOTSTRAP)

After the bootstrap runs, you **must** login before using rbw:

```bash
# Option 1: Use the interactive setup script
bash bitwarden-setup.sh

# Option 2: Manual setup
rbw login              # Enter your Bitwarden email and master password
rbw sync              # Sync your vault from server
rbw list              # Verify you can see your vault entries
```

## Usage

### Command-line usage (rbw)
```bash
# List all entries (requires vault to be synced)
rbw list

# Get a password for an entry
rbw get "Gmail"

# Get a specific field (username, url, etc)
rbw get "Gmail" username

# Sync vault with server
rbw sync

# Check vault status
rbw status

# Lock the vault (logout)
rbw lock

# Unlock the vault
rbw unlock
```

### Rofi-based selection (rbw-rofi)
```bash
# Launch rofi password selector
rbw-rofi

# Alternative: use in i3 keybinding
# Add to ~/.config/i3/config:
# bindsym $mod+p exec --no-startup-id rbw-rofi
```

You can also pipe output:
```bash
# Copy password to clipboard
rbw get "Gmail" | xclip -selection clipboard
```

## File Locations

- **Config**: `~/.config/rbw/config.toml`
- **Cache**: `~/.local/share/rbw/`
- **Master Key**: `~/.local/share/rbw/` (encrypted locally)

## Troubleshooting

### rbw login fails with "invalid credentials"
```bash
# Verify you're using the correct email and master password
# Try again with careful input
rbw login
```

### "Vault is locked" error
```bash
# Unlock the vault (requires master password)
rbw unlock

# Or re-login
rbw login
```

### rbw-rofi not finding entries
```bash
# 1. Verify vault is synced
rbw sync

# 2. Check vault status
rbw status

# 3. Unlock if needed
rbw unlock

# 4. Try rofi again
rbw-rofi
```

### How long does rbw keep vault in memory?
Check your config file:
```bash
grep lock_timeout ~/.config/rbw/config.toml
```
Default is 3600 seconds (1 hour). After this time, the vault is automatically locked.

### Missing dependencies
The bootstrap should install all required packages via pacman/AUR:
```bash
pacman -Qs rbw              # Check if installed
pacman -Qs rofi
yay -Qs rofi-rbw
yay -Qs bitwarden-systemd
```

If any are missing, install manually:
```bash
yay -S rbw rofi-rbw bitwarden-systemd
```

## Integration Examples

### i3 window manager
Add to `~/.config/i3/config`:
```
# Password manager (requires rbw-rofi)
bindsym $mod+p exec --no-startup-id "rbw-rofi"
```

### Sway window manager
Add to `~/.config/sway/config`:
```
# Password manager
bindsym $mod+p exec "rbw-rofi"
```

### zsh shell aliases
Add to `~/.zshrc`:
```bash
alias pw='rbw get'
alias pws='rbw sync'
alias pwl='rbw list'
alias pwu='rbw unlock'
alias pwx='rbw lock'
```

### bash shell functions
Add to `~/.bashrc`:
```bash
pw() {
    rbw get "$1"
}
pw-copy() {
    rbw get "$1" | xclip -selection clipboard
    echo "Copied to clipboard"
}
```

## Common Workflows

### Quick password lookup
```bash
rbw get "Gmail"  # Shows username and password
```

### Copy password to clipboard
```bash
rbw get "Gmail" | xclip -selection clipboard
```

### Using with other tools
```bash
# Get password in a script
password=$(rbw get "myserver" password)

# Use in SSH
ssh user@$(rbw get "myserver" url)
```

## References

- [rbw GitHub](https://github.com/doy/rbw)
- [rbw-rofi GitHub](https://github.com/fdw/rbw-rofi)
- [Bitwarden Vault](https://vault.bitwarden.com)
- [systemd-bw GitHub](https://github.com/3v1n0/systemd-bw)

