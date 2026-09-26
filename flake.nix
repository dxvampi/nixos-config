{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs name; };

          modules = [
            ./hosts/${name}
          ];
        };
    in
    {
      nixosConfigurations = {
        nvidiagc = mkHost "nvidiagc";
        amdgc = mkHost "amdgc";
        intelgc = mkHost "intelgc";
      };
    };
}
