{
  description = "NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-index-database,
      ...
    }:
    {
      nixosConfigurations.mrphil2105-NixLaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
        ];
      };
      homeConfigurations."mrphil2105@mrphil2105-NixLaptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ./home/home.nix
          nix-index-database.homeModules.nix-index
          { programs.nix-index-database.comma.enable = true; }
        ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
}
