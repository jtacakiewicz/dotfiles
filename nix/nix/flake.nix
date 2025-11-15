{
    description = "Unified Darwin + Home Manager flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-colors.url = "github:misterio77/nix-colors";
    };

    outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
        let
            systems = {
                darwin = "aarch64-darwin";
                linux = "x86_64-linux";
            };
        in
            rec {
            darwinConfigurations."Jans-MacBook-Air" = let
                pkgs = import nixpkgs { system = systems.darwin; };
                homeConfigs = import ./home-manager/home.nix { inherit pkgs inputs home-manager; };
            in nix-darwin.lib.darwinSystem {
                    system =  "aarch64-darwin";
                    modules = [
                        darwin/macos-conf.nix
                        home-manager.darwinModules.home-manager
                        {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;

                            home-manager.users.epi = homeConfigs.darwin;
                        }
                    ];
                };

            homeConfigurations."jamjan-linux" = let
                pkgs = import nixpkgs { system = systems.linux; };
                homeConfigs = import ./home-manager/home.nix { inherit pkgs inputs home-manager; };
            in
                homeConfigs.nixos;
        };
}

