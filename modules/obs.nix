{ pkgs, ... }:

let
  obsWithCuda = pkgs.obs-studio.override {
    cudaSupport = true;
  };
in
{
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;

    package = obsWithCuda;

    plugins = with pkgs.obs-studio-plugins; [
      obs-vkcapture
    ];
  };
}
