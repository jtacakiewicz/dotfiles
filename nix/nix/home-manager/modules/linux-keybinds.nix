{ config, pkgs, inputs, ... }:

{
    home.packages = with pkgs; [
        gnomeExtensions.tiling-assistant
        gnome-screenshot
        gnomeExtensions.hide-top-bar
    ];
    dconf.settings = {
        "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [ 
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            ];
        };
        "org/gnome/desktop/wm/keybindings".close = ["<Alt>q"];
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
            { 
                binding = "<Primary><Alt>t";
                command = "alacritty";
                name = "open-terminal";
            };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
            { 
                binding = "<Super><Shift>s";
                command = "gnome-screenshot -i";
                name = "screenshot tool";
            };
        "org/gnome/desktop/wm/keybindings" = {
            move-to-workspace-left = ["<Super><Control>Left"];
            move-to-workspace-right = ["<Super><Control>Right"];
            move-to-monitor-left = ["<Super><Shift>Left"];
            move-to-monitor-right = ["<Super><Shift>Right"];
            switch-to-workspace-right = ["<Control>Right"];
            switch-to-workspace-left = ["<Control>Left"];
            switch-windows = ["<Alt>Tab"];
            switch-windows-backward = ["<Shift><Alt>Tab"];
        };
        "org/gnome/shell/extensions/tiling-assistant" = {
            tile-right-half =      ["<Control><Alt>Right"];
            tile-left-half =       ["<Control><Alt>Left"];
            tile-top-half =        ["<Control><Alt>Up"];
            tile-bottom-half =     ["<Control><Alt>Down"];
            tile-topleft-quarter=  ["<Shift><Control><Alt>Left"];
            tile-topright-quarter= ["<Shift><Control><Alt>Right"];
            tile-bottomleft-quarter=  ["<Super><Control><Alt>Left"];
            tile-bottomright-quarter= ["<Super><Control><Alt>Right"];
        };
    };
}
