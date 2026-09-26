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

- **hosts/** > per-machine entry points + shared host configuration
- **modules/** > system-level NixOS modules: packages, audio, bluetooth, hyprland, sddm, gpu-*
- **home/** > user-level (Home Manager) modules
- **dotfiles/** > raw config files
- **assets/** > images, sounds, etc...

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

### 4. Define variables
By default the username is `dxvampi`. The hostname is set automatically from the chosen host folder (`nvidiagc`, `amdgc` or `intelgc`), so each machine gets its own name on the network.

To change the username, modify `~/nixos-config/config.nix`

### 5. Rebuild

Run this command:
```bash
sudo nixos-rebuild switch --flake .#<config-name>
```

Where `<config-name>` is one of: `nvidiagc`, `amdgc`, `intelgc` (matches the `hosts/` folder chosen above).

Home Manager will automatically rename any pre-existing dotfiles in `~/.config` to `<file>.backup` during the first activation, so there's no need to remove them manually beforehand.

### 6. Verify

```bash
systemctl status home-manager-dxvampi.service
ls -l ~/.config/ | grep -E "hypr|noctalia|rofi|kitty"
```

The symlinks should resolve (following the chain) to `~/nixos-config/dotfiles/`.

### 7. Post-install problems/tips

System-wide packages are defined in:

    `modules/packages.nix`

To install a new system-wide package, add it to:

    `environment.systemPackages`

inside `modules/packages.nix`.

If a package or configuration is specific to one GPU/host, keep it in the corresponding host-specific module.
```nix
environment.systemPackages = with pkgs; [
    neovim
    wget
    # packages...
    yourpackage # <- HERE
    # more packages...
  ];
```

If your monitor's refresh rate is wrong, position is wrong, etc. Modify `dotfiles/monitors.lua`. [See wiki](https://wiki.hypr.land/configuring/core/monitors/)

If your keyboard layout isn't correct, modify `dotfiles/hyprland.lua`. [See wiki](https://wiki.hypr.land/configuring/core/config-options/#input)

If you want to add new dotfiles to reproduce them, you need to do the following
#### Adding new dotfiles
1. Drag the dotfile to `dotfiles/whateveryouwant`
2. Add a new .nix file to `home`
3. Put this on the file:
```nix
{ config, dotfiles, ... }:

{
  xdg.configFile."whateveryouwant".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/whateveryouwant";
}
```
4. Import it on `default.nix`

## Subsequent rebuilds

```bash
cd ~/nixos-config
git pull
sudo nixos-rebuild switch --flake .#<config-name>
```

## Wallpaper / assets

Background images live in `assets/` at the repo root. Since dotfiles are symlinked out-of-store (`mkOutOfStoreSymlink`), you can reference the wallpaper with an absolute path in your Hyprland config, e.g.:

```lua
hl.exec_cmd("swaybg -m stretch -i $HOME/nixos-config/assets/clouds-3.png")
```

## Notes

- Editing files under `dotfiles/` takes effect immediately, no rebuild or restart required, since they are symlinked directly to the repo.
- A system-level change (anything under `modules/` or `hosts/`) always requires a rebuild.