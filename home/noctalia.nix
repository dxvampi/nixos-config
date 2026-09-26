{
  config,
  dotfiles,
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/noctalia";

}
