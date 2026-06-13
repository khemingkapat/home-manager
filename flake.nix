{
  description = "Home Manager configuration of khemi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixgl,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkHome =
        { isDesktop }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit nixgl isDesktop; };
        };
    in
    {
      homeConfigurations."khemi" = mkHome { isDesktop = true; };
      homeConfigurations."khemi-wsl" = mkHome { isDesktop = false; };
    };
}
