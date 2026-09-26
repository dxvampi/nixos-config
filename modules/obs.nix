{ config, lib, pkgs, ... }:

let
  cfg = config.custom.obs;
in
{
  options.custom.obs.cudaSupport = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Compilar OBS Studio con soporte CUDA (solo tiene sentido en hosts con GPU NVIDIA).";
  };

  config = {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;

      package = pkgs.obs-studio.override {
        cudaSupport = cfg.cudaSupport;
      };

      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
      ];
    };
  };
}
