{ pkgs, input, ... }:

{
  nixpkgs.config.allowUnfree = true;

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
    gnupg

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
    gparted-full

    # KDE
    kdePackages.kate

    # Fonts/Other
    nerd-fonts.jetbrains-mono

    # Authentication
    inputs.bb-auth.packages.${pkgs.system}.default
  ];
}
