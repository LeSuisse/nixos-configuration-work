{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };   
  outputs = { self, nixpkgs, unstable, lanzaboote, home-manager, nixos-hardware }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.ENA-LAP-00068 = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { unstablePkgs = unstable.legacyPackages.${system}; };
      modules = [
        lanzaboote.nixosModules.lanzaboote
        nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.tgerbet = import ./home.nix;
          home-manager.extraSpecialArgs = { unfreePkgs = import unstable { config.allowUnfree = true; inherit system; }; };
        }
      ];
    };
  };
}
