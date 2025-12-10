{
    description = "Unified Darwin + Home Manager flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

        homebrew-core = {
            url = "github:homebrew/homebrew-core";
            flake = false;
        };
        homebrew-cask = {
            url = "github:homebrew/homebrew-cask";
            flake = false;
        };
        aerospace-tap = {
            url = "github:nikitabobko/AeroSpace";
            flake = false;
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-colors.url = "github:misterio77/nix-colors";
    };

    outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, homebrew-core, homebrew-cask, aerospace-tap, home-manager, ... }:
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
                    system =  systems.darwin;
                    modules = [
                        ./darwin/macos-conf.nix
                        nix-homebrew.darwinModules.nix-homebrew
                        {
                            nix-homebrew = {
                                enable = true;
                                enableRosetta = true;
                                user = "epi";
                                autoMigrate = true;
                                taps = {
                                    "homebrew/homebrew-core" = homebrew-core;
                                    "homebrew/homebrew-cask" = homebrew-cask;
                                    "nikitabobko/aerospace" = aerospace-tap;
                                };
                            };
                        }
                        ({ config, ... }: {
                            homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
                        })
                    ];

                };

            homeConfigurations."jamjan-linux" = let
                pkgs = import nixpkgs { system = systems.linux; };
                homeConfigs = import ./home-manager/home.nix { inherit pkgs inputs home-manager; };
            in
                homeConfigs.nixos;

            nixosConfigurations."jamjan-linux" = nixpkgs.lib.nixosSystem {
                system = systems.linux; # Assuming 'systems' is defined and 'linux' is "x86_64-linux"
                modules = [
                    ({ config, pkgs, ... }: 
                        import ./nixos/configuration.nix { inherit config pkgs inputs home-manager; }
                    )
                ];
            };
        };
}

