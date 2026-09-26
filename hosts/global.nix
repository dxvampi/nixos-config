{
  config,
  pkgs,
  inputs,
  name,
  ...
}:

let
  settings = import ../config.nix;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../modules/audio.nix
    ../modules/bluetooth.nix
    ../modules/hyprland.nix
    ../modules/obs.nix
    ../modules/packages.nix
    ../modules/sddm.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Red
  networking.hostName = name;
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
  };

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = {
    inherit inputs;
  };

  home-manager.users.${settings.username} = import ../home;

  # Versiones
  system.stateVersion = "26.05";
}
