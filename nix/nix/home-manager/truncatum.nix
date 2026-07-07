
{ config, pkgs, inputs, ... }:

{
    imports = [
        ./modules/ollama.nix
    ];
    home.packages = with pkgs; [
        libGL
    ];
 }
