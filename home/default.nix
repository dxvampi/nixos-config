{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./kitty.nix
    ./rofi.nix
    ./swayosd.nix
    ./waybar.nix
    ./gpg.nix
  ];

  _module.args.dotfiles = "/home/dxvampi/nixos-config/dotfiles";

  home.stateVersion = "26.05";
}
