{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  users.users.dxvampi.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    lazydocker
  ];
}
