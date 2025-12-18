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
        mrphil2105-NixLaptop = {
          host = "laptop";
          user = "mrphil2105";
        };
        mrphil2105-NixDesktop = {
          host = "desktop";
          user = "mrphil2105";
        };
      };
      mkNixos =
        hostname: cfg:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system/configuration.nix
            ./system/hosts/${cfg.host}.nix
          ];
          specialArgs = {
            inherit inputs;
            host = cfg.host;
          };
        };
      mkHome =
        hostname: cfg:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/home.nix
            ./home/hosts/${cfg.host}.nix
            nix-index-database.homeModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
          ];
          extraSpecialArgs = {
            inherit inputs;
            host = cfg.host;
          };
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkNixos hosts;
      homeConfigurations = nixpkgs.lib.mapAttrs' (hostname: cfg: {
        name = "${cfg.user}@${hostname}";
        value = mkHome hostname cfg;
      }) hosts;
    };
}
