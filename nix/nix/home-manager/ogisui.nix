
{ config, pkgs, inputs, ... }:

{
    imports = [
        ./modules/linux-gaming.nix
        ./modules/llama-cpp.nix
        ./modules/linux-keybinds.nix
        ./modules/webapps.nix
        ./modules/sway.nix
    ];
    home.packages = with pkgs; [
        gimp
        vlc

        libGL
        proton-pass
    ];
    xdg.mimeApps = {
        enable = true;
        defaultApplications = {
            "video/mp4" = [ "vlc" ];
            "video/x-matroska" = [ "vlc" ];
            "video/x-msvideo" = [ "vlc" ];
            "video/quicktime" = [ "vlc" ];
            "video/webm" = [ "vlc" ];
            "video/ogg" = [ "vlc" ];
            "audio/mpeg" = [ "vlc" ];
            "audio/ogg" = [ "vlc" ];
            "audio/aac" = [ "vlc" ];
            "audio/x-flac" = [ "vlc" ];
        };
    };

}
