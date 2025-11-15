{ pkgs, config, ... }:
{
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = [
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
        pkgs.git
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
            "syncthing"
        ];
        casks = [
            "aerospace"
            "docker"
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

    fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
    ];

    nix.settings.experimental-features = "nix-command flakes";

    programs.zsh.enable = true;

    system.configurationRevision = config.self.rev or config.self.dirtyRev or null;
    system.stateVersion = 5;

    nixpkgs.hostPlatform = "aarch64-darwin";
}

