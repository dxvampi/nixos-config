{ config, dotfiles, ... }:

{
  xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hypr";
}
