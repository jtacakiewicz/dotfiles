{ pkgs, ... }:

{
    imports = [
        ./alacritty.nix
    ];
    home.packages = [
        pkgs.lazygit
        pkgs.zsh
        pkgs.gnumake
        pkgs.unzip
        pkgs.stow
        pkgs.tmux
        pkgs.zoxide

        pkgs.fzf
        pkgs.ripgrep
        # pkgs.gcc
        pkgs.clang-tools
        pkgs.clang
        pkgs.cmake
        pkgs.ninja

        pkgs.python312
    ];
}
