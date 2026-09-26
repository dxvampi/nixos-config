{
  imports = [
    ./hardware-configuration.nix

    ../global.nix

    ../../modules/gpu-nvidia.nix
    ../../modules/obs.nix
  ];
}
