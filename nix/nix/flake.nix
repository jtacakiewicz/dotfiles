{
    description = "Epic Darwin system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

        # Optional: Declarative tap management
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

    outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, aerospace-tap}:
        let
            configuration = { pkgs, config, ... }: {
                # List packages installed in system profile. To search by name, run:
                # $ nix-env -qaP | grep wget
                nixpkgs.config.allowUnfree = true;
                environment.systemPackages =
                    [ 
                        pkgs.neovim
                        pkgs.tmux

                        pkgs.mkalias
                        pkgs.go
                        pkgs.glslang
                        pkgs.llvm
                        pkgs.yarn
                        # pkgs.python3

                        pkgs.zoxide
                        pkgs.stow
                        pkgs.docker

                        pkgs.fd
                        pkgs.fzf
                        pkgs.ripgrep
                        pkgs.htop
                        pkgs.jq
                        pkgs.lazygit
                        pkgs.inetutils
                        pkgs.putty
                        pkgs.wget

                        pkgs.clang-tools
                        pkgs.cmake
                        pkgs.codespell
                        pkgs.conan
                        pkgs.cppcheck
                        pkgs.doxygen
                        pkgs.gtest
                        pkgs.lcov
                        pkgs.vcpkg

                        pkgs.pngpaste
                        pkgs.xclip
                        pkgs.portaudio
                        pkgs.qemu


                        # pkgs.hyprland
                        pkgs.alt-tab-macos
                        pkgs.wireshark
                        pkgs.spicetify-cli
                    ];
                homebrew = {
                    enable = true;
                    brews = [
                        "libomp"
                    ];
                    casks = [
                        "hammerspoon"
                        "the-unarchiver"
                        "intellij-idea-ce"
                        "aerospace"
                    ];
                    # onActivation.cleanup = "zap";
                    onActivation.autoUpdate = true;
                    onActivation.upgrade = true;
                };
                system.defaults = {
                    # minimal dock
                    dock = {
                        autohide = true;
                        orientation = "left";
                        show-process-indicators = false;
                        show-recents = false;
                        static-only = true;
                    };
                    # a finder that tells me what I want to know and lets me work
                    finder = {
                        AppleShowAllExtensions = true;
                        ShowPathbar = true;
                        FXEnableExtensionChangeWarning = false;
                        FXDefaultSearchScope = "clmv";
                    };
                };
                fonts.packages = [
                    pkgs.nerd-fonts.jetbrains-mono
                ];
          #       system.activationScripts.applications.text = let
          #           env = pkgs.buildEnv {
          #               name = "system-applications";
          #               paths = config.environment.systemPackages;
          #               pathsToLink = "/Applications";
          #           };
          #       in
          #           pkgs.lib.mkForce ''
          # # Set up applications.
          # echo "setting up /Applications..." >&2
          # rm -rf /Applications/Nix\ Apps
          # mkdir -p /Applications/Nix\ Apps
          # find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          # while read src; do
          #   app_name=$(basename "$src")
          #   echo "copying $src" >&2
          #               ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          # done
          #           '';

                # Necessary for using flakes on this system.

                nix.settings.experimental-features = "nix-command flakes";

                # Enable alternative shell support in nix-darwin.
                programs.zsh.enable = true;

                # Set Git commit hash for darwin-version.
                system.configurationRevision = self.rev or self.dirtyRev or null;

                # Used for backwards compatibility, please read the changelog before changing.
                # $ darwin-rebuild changelog
                system.stateVersion = 5;

                # The platform the configuration will be used on.
                nixpkgs.hostPlatform = "aarch64-darwin";
            };
        in
        {
            # Build darwin flake using:
            # $ darwin-rebuild build --flake .#simple
            darwinConfigurations."Jans-MacBook-Air" = nix-darwin.lib.darwinSystem {
                modules = [ 
                    configuration 
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
                    ({config, ...}: {
                        homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
                    })
                ];
            };

            # Expose the package set, including overlays, for convenience.
            darwinPackages = self.darwinConfigurations."Jans-MacBook-Air".pkgs;
        };
}
