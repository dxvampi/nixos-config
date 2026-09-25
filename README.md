# nixos-config

Modular NixOS configuration using flakes + Home Manager, supporting multiple machines (NVIDIA, AMD, Intel) from a single repository.

## Structure

```
.
├── flake.nix
├── hosts/
│   ├── nvidiagc/
│   ├── amdgc/
│   └── intelgc/
├── modules/
├── home/
├── dotfiles/
└── assets/
```

- **hosts/** > per-machine entry points (hardware-configuration.nix + machine-specific imports)
- **modules/** > system-level (NixOS) modules: audio, bluetooth, hyprland, sddm, gpu-\*
- **home/** > user-level (Home Manager) modules
- **dotfiles/** > raw config files (hypr, rofi, waybar, swayosd...), symlinked into `~/.config` via Home Manager
- **assets/** > where the images/sounds/etc... used on the rice will live

## Installing on a new machine

### 1. Enable flakes and git temporarily

On a fresh NixOS install, edit the default config:

```bash
sudo nano /etc/nixos/configuration.nix
```

Add inside the main block:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];

environment.systemPackages = with pkgs; [
  git
];
```

Apply the change:

```bash
sudo nixos-rebuild switch
```

### 2. Clone the repo

```bash
git clone https://github.com/dxvampi/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

### 3. Generate this machine's hardware-configuration.nix

Pick the folder that matches this machine's GPU:

- NVIDIA → `hosts/nvidiagc`
- AMD → `hosts/amdgc`
- Intel → `hosts/intelgc`

Run this command: *(replace \<chosen-folder> with the name of the folder)*
```bash
sudo nixos-generate-config --show-hardware-config > hosts/<chosen-folder>/hardware-configuration.nix
```

This file is unique per machine (disk UUIDs, kernel modules) and is never shared between machines.

### 4. Rebuild

Run this command:
```bash
sudo nixos-rebuild switch --flake .#<config-name>
```

Where `<config-name>` is one of: `nvidiagc`, `amdgc`, `intelgc` (matches the `hosts/` folder chosen above).

Home Manager will automatically rename any pre-existing dotfiles in `~/.config` to `<file>.backup` during the first activation, so there's no need to remove them manually beforehand.

### 5. Verify

```bash
systemctl status home-manager-dxvampi.service
ls -l ~/.config/ | grep -E "hypr|waybar|rofi|swayosd|kitty"
```

The symlinks should resolve (following the chain) to `~/nixos-config/dotfiles/`.

## Subsequent rebuilds

```bash
cd ~/nixos-config
git pull
sudo nixos-rebuild switch --flake .#<config-name>
```

## GPG

After the first rebuild, generate your key if you don't already have one:

```bash
gpg --full-generate-key
```

The passphrase prompt appears via rofi (`pinentry-rofi`), configured in `home/gpg.nix`.

## Wallpaper / assets

Background images live in `assets/` at the repo root. Since dotfiles are symlinked out-of-store (`mkOutOfStoreSymlink`), you can reference the wallpaper with an absolute path in your Hyprland config, e.g.:

```lua
hl.exec_cmd("swaybg -m stretch -i $HOME/nixos-config/assets/clouds-3.png")
```

## Notes

- Assumes the user is always `dxvampi` across machines.
- If the repo is private, `git clone` over HTTPS will prompt for authentication — use SSH or a token as needed.
- Editing files under `dotfiles/` takes effect immediately, no rebuild required, since they are symlinked directly to the repo.
- A system-level change (anything under `modules/` or `hosts/`) always requires a rebuild.