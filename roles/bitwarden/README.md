# Bitwarden role

Sets up [rbw](https://github.com/doy/rbw) (Rust Bitwarden CLI).

## What it does

- Creates `~/.config/rbw/config.json` with your email and lock timeout
- Packages (`rbw`, `rofi-rbw`, `bitwarden-systemd`) are installed by the `packages` role

## After bootstrap

```bash
rbw register   # register this device
rbw login      # authenticate
rbw sync       # pull vault
rbw list       # verify
```

## Usage

```bash
rbw get 'entry-name'   # get a password
rofi-rbw               # rofi picker
rbw lock               # lock vault
```
