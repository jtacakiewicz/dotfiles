{
    description = "Epic Darwin system flake";

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
    };

    outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, aerospace-tap }:
        {
            # darwin-rebuild switch --flake .
            darwinConfigurations."Jans-MacBook-Air" = nix-darwin.lib.darwinSystem {
                modules = [
                    ./macos-conf.nix
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

            darwinPackages = self.darwinConfigurations."Jans-MacBook-Air".pkgs;
        };
}

