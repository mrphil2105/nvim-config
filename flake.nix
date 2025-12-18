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
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      hosts = {
        mrphil2105-NixLaptop = "laptop";
        mrphil2105-NixDesktop = "desktop";
      };
      mkNixos =
        hostname: host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/${host}/configuration.nix ];
          specialArgs = {
            inherit inputs;
            inherit host;
          };
        };
      mkHome =
        hostname: host:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./hosts/${host}/home.nix
            nix-index-database.homeModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit host;
          };
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkNixos hosts;
      homeConfigurations = nixpkgs.lib.mapAttrs' (hostname: host: {
        name = "mrphil2105@${hostname}";
        value = mkHome hostname host;
      }) hosts;
    };
}
