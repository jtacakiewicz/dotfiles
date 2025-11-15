{ pkgs, config, ... }:

{
    home.packages = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.alacritty
    ];
}
