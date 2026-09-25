{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/audio.nix
    ../../modules/bluetooth.nix
    ../../modules/hyprland.nix
    ../../modules/gpu-intel.nix
    ../../modules/sddm.nix
  ];

  let
    settings = import ../../config.nix;
  in

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Red
  networking.hostName = settings.hostname;
  networking.networkmanager.enable = true;

  # Zona horaria y locale
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Teclado
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };
  console.keyMap = "es";

  # Escritorio
  services.desktopManager.plasma6.enable = true;

  # Impresión
  services.printing.enable = true;

  # Usuario
  users.users.${settings.username} = {
    isNormalUser = true;
    description = settings.username;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Paquetes
  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    zsh
    fastfetch
    eza
    kitty
    nautilus
    librewolf
    pear-desktop
    vscodium
    mpv
    yazi
    nixfmt

    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "26.05";
}
