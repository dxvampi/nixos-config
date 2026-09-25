{ config, pkgs, ... }:

let
  settings = import ../config.nix;
in
{
  imports = [
    ./hyprland.nix
    ./kitty.nix
    ./rofi.nix
    ./swayosd.nix
    ./waybar.nix
    ./gpg.nix
  ];

  _module.args.dotfiles = "/home/${settings.username}/nixos-config/dotfiles";

  home.stateVersion = "26.05";
}
