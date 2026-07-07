{ config, pkgs, inputs, ... }:

{
    imports = [
        ./modules/firefox.nix
    ];
    home.packages = with pkgs; [
        obsidian
        spotify
    ];
    programs.home-manager.enable = true;
}
