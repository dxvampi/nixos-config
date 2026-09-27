{ config, pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-rofi;
  };

  programs.zsh.initContent = ''
    export GPG_TTY="$(tty)"
  '';
}
