{ config, dotfiles, ... }:

{
  xdg.configFile."swayosd".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/swayosd";
}
