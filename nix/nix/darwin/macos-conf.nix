{ pkgs, config, ... }:
{
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = [
        pkgs.home-manager

        pkgs.mkalias
        pkgs.go
        pkgs.glslang
        pkgs.llvm
        pkgs.yarn
        # pkgs.python3

        pkgs.fd
        pkgs.htop
        pkgs.jq
        pkgs.inetutils
        pkgs.putty
        pkgs.wget

        pkgs.codespell
        pkgs.conan
        pkgs.cppcheck
        pkgs.doxygen
        pkgs.gtest
        pkgs.lcov
        # pkgs.vcpkg

        pkgs.pngpaste
        pkgs.xclip
        pkgs.portaudio
        pkgs.qemu

        # pkgs.hyprland
    ];

    homebrew = {
        enable = true;
        brews = [
            "libomp"
        ];
        casks = [
            "aerospace"
        ];
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
    };
    system.primaryUser = "epi";

    system.defaults = {
        dock = {
            autohide = true;
            orientation = "left";
            show-process-indicators = false;
            show-recents = false;
            static-only = true;
        };

        finder = {
            AppleShowAllExtensions = true;
            ShowPathbar = true;
            FXEnableExtensionChangeWarning = false;
            FXDefaultSearchScope = "clmv";
        };
    };
    services.tailscale.enable = true;

    fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
    ];

    nix.settings.experimental-features = "nix-command flakes";

    system.configurationRevision = config.self.rev or config.self.dirtyRev or null;
    system.stateVersion = 5;

    nixpkgs.hostPlatform = "aarch64-darwin";
}

