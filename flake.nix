{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
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
  outputs = { self, nixpkgs, lanzaboote, home-manager, nixos-hardware }: {
    nixosConfigurations.work = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        lanzaboote.nixosModules.lanzaboote
        nixos-hardware.nixosModules.lenovo-thinkpad-t480
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.tgerbet = import ./home.nix;
          home-manager.extraSpecialArgs = { unfreePkgs = import nixpkgs { config.allowUnfree = true; system = "x86_64-linux"; }; };
        }
      ];
    };
  };
}
