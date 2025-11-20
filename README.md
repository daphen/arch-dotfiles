# Arch Linux Dotfiles

My personal configuration files for Arch Linux, managed with GNU Stow.

## Contents

- **niri** - Scrollable tiling Wayland compositor configuration
- **waybar** - Status bar configuration and scripts
- **fish** - Fish shell configuration and functions
- **kanata** - Keyboard remapping configuration
- **themes** - Centralized theme management system
- **systemd** - User systemd services
- **bin** - Custom scripts and utilities

## Installation

### Prerequisites

```bash
sudo pacman -S git stow
```

### Clone and Deploy

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Deploy all configurations
cd ~/dotfiles
stow niri waybar fish kanata themes systemd bin

# Or deploy individual packages
stow niri  # Just the niri window manager config
```

## Packages

### niri
- Window manager configuration (`config.kdl`)
- Custom navigation scripts for workspace/monitor switching
- Screenshot to clipboard script

### waybar
- Status bar configuration
- Custom scripts for wifi and audio menus
- Niri workspace minimap

### fish
- Shell configuration with custom prompt
- Theme toggling functions
- Various utility functions

### kanata
- Custom keyboard layout with Swedish characters
- XKB keymap configuration

### themes
- Centralized theme manager for all tools
- Dark/light mode switching
- Theme generation scripts

### bin
- `niri-focus-tracker` - Window focus history tracker (with memory leak protection)
- `niri-jump-or-exec` - Jump to or execute applications
- `sysinfo` - System information display

## Key Bindings

### Window Management
- `Super+h/l` - Focus left/right window
- `Super+j/k` - Focus down/up workspace
- `Super+Space` - Application launcher (vicinae)

### Applications
- `Super+d` - WezTerm terminal
- `Super+f` - Zen browser
- `Super+e` - Yazi file manager
- `Super+g` - Claude Code
- `Super+c` - Discord (Vesktop)

### System
- `Super+Ctrl+t` - Toggle dark/light theme
- `Super+Ctrl+Shift+e` - Screenshot selection to clipboard
- `Super+Ctrl+q` - Lock screen

## Backup Existing Configs

Before deploying, backup your existing configurations:

```bash
mkdir ~/config-backup
cp -r ~/.config/niri ~/.config/waybar ~/.config/fish ~/config-backup/
```

## Restoring from Backup

If you need to restore your original configs:

```bash
# Remove symlinks
cd ~/dotfiles
stow -D niri waybar fish kanata themes systemd bin

# Restore from backup
cp -r ~/config-backup/* ~/.config/
```

## Updates

To update configurations:

1. Edit files directly (they're symlinked)
2. Commit changes:
   ```bash
   cd ~/dotfiles
   git add .
   git commit -m "Update configs"
   git push
   ```

## License

Personal configuration files - feel free to use and modify as needed.