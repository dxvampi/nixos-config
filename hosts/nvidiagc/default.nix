{
  imports = [
    ./hardware-configuration.nix

    ../global.nix

    ../../modules/gpu-nvidia.nix
  ];

  custom.obs.cudaSupport = true;
}
