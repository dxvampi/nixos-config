{ config, pkgs, ... }:

{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
  ];
}
