{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    swayosd
    swaybg
    rofi
    grim
    slurp
    wl-clipboard
    hyprpolkitagent
    playerctl
    pavucontrol
  ];
}
