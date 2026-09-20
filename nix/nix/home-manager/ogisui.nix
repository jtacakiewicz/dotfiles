
{ config, pkgs, inputs, ... }:

{
    imports = [
        ./modules/linux-gaming.nix
        ./modules/llama-cpp.nix
        ./modules/linux-keybinds.nix
        ./modules/opencode.nix
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
            "video/mpeg" = [ "vlc" ];
            "video/x-flv" = [ "vlc" ];
            "video/x-ms-wmv" = [ "vlc" ];
            "video/3gpp" = [ "vlc" ];
            "audio/mpeg" = [ "vlc" ];
            "audio/ogg" = [ "vlc" ];
            "audio/aac" = [ "vlc" ];
            "audio/x-flac" = [ "vlc" ];
            "audio/wav" = [ "vlc" ];
            "audio/x-wav" = [ "vlc" ];
            "audio/mp4" = [ "vlc" ];
            "audio/webm" = [ "vlc" ];
            "audio/x-matroska" = [ "vlc" ];
            "audio/x-ms-wma" = [ "vlc" ];
            "audio/opus" = [ "vlc" ];
        };
    };

}
