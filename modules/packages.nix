{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  environment.systemPackages = with pkgs; [
    # CLI / system
    neovim
    wget
    git
    zsh
    fastfetch
    eza
    btop
    yazi
    mesa-demos

    # Dev
    vscodium
    lua-language-server
    nixfmt

    # Desktop
    kitty
    nautilus
    librewolf
    pear-desktop
    mpv
    filezilla
    vesktop
    gnome-disk-utility
    prismlauncher

    # KDE
    kdePackages.kate

    # Fonts/Other
    nerd-fonts.jetbrains-mono
  ];
}
