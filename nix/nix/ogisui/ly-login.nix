{ config, lib, pkgs, ... }:

let
    palette = [
        # --- normal ---
        { r =    46; g =    52; b =    64; }
        { r = 191; g =    97; b = 106; }
        { r = 163; g = 190; b = 140; }
        { r = 235; g = 203; b = 139; }
        { r =    94; g = 129; b = 172; }
        { r = 180; g = 142; b = 173; }
        { r = 136; g = 192; b = 208; }
        { r = 216; g = 222; b = 233; }
        # --- bright ---
        { r =    76; g =    86; b = 106; }
        { r = 191; g =    97; b = 106; }
        { r = 163; g = 190; b = 140; }
        { r = 235; g = 203; b = 139; }
        { r = 129; g = 161; b = 193; }
        { r = 180; g = 142; b = 173; }
        { r = 143; g = 188; b = 187; }
        { r = 236; g = 239; b = 244; }
    ];

    reds     = lib.concatStringsSep "," (map (c: toString c.r) palette);
    greens = lib.concatStringsSep "," (map (c: toString c.g) palette);
    blues    = lib.concatStringsSep "," (map (c: toString c.b) palette);
in
{
    systemd.services.nord-console-colors = {
        description = "Apply Nord color palette to the virtual console";
        wantedBy = [ "display-manager.service" ];
        before     = [ "display-manager.service" ];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
        };
        script = ''
            printf '%s\n' \
                '${reds}' \
                '${greens}' \
                '${blues}' \
            | ${pkgs.kbd}/bin/setvtrgb -
        '';
    };

    services.displayManager.ly = {
        enable = true;
        x11Support = true;

        settings = {
            bg = 1;
            fg = 8;
            border_fg = 7;
            error_fg = 2;

            animation = "none";
            hide_borders = false;
            hide_key_hints = true;
            hide_version_string = true;
        };
    };
}
