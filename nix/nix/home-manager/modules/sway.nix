
{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        tofi # app launcher
        yazi # file manager
    ];
    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraOptions = [ "--unsupported-gpu" ];
    };
    programs.waybar.enable = true;
}
