{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    playerctl
    pavucontrol
  ];
}
