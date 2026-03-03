
{ config, pkgs, inputs, ... }:

{
    imports = [
        ./modules/linux-gaming.nix
        ./modules/ollama.nix
        ./modules/linux-keybinds.nix
        ./modules/webapps.nix
    ];
    home.packages = with pkgs; [
        gimp
        vlc

        libGL
        proton-pass
    ];
    home.username = "jamjan";
    home.homeDirectory = "/home/jamjan";
}
