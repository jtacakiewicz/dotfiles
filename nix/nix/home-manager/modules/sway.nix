{ config, pkgs, ... }:

{
  home.pointerCursor = {
    name = "macOS";
    package = pkgs.apple-cursor;
    size = 24;
  };

  home.packages = with pkgs; [
    tofi # app launcher
    yazi # file manager
    dragon-drop # drag-and-drop-yazi
    grim # ss tool
    slurp # ss tool
    wl-clipboard # clipboard
    jq # scripts
    zathura # documents
    imv # pictures
  ];

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      recolor = true;
      recolor-keephue = true; 
      recolor-reverse-video = true;
      default-bg = "#2e3440";
      default-fg = "#d8dee9";
      recolor-lightcolor = "#2e3440"; # Map white pages to Nord Dark
      recolor-darkcolor = "#eceff4";  # Map black text to Nord Light
    };
    mappings = {
      "<C-e>" = "scroll down";
      "<C-y>" = "scroll up";
    };
  };

  programs.imv = {
    enable = true;
    settings = {
      options = {
        background = "2e3440"; 
        fullscreen = false;
      };
      binds = {
        "<bracketright>" = "next";            # Next image
        "<bracketleft>" = "prev";             # Previous image
        "f" = "fullscreen";
        "r" = "rotate by 90";
        "q" = "close";
      };
    };
  };

  programs.waybar.enable = true;

  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };

  xdg = {
    enable = true;

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/webp" = "imv.desktop";
        "image/bmp" = "imv.desktop";
        "image/tiff" = "imv.desktop";
        "inode/directory" = "yazi.desktop";
      };
    };

    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-termfilechooser
      ];

      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.Inhibit" = [ "none" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
        
        sway = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        };
      };
    };

    configFile."xdg-desktop-portal-termfilechooser/config" = {
      text = ''
        [filechooser]
        cmd=${pkgs.writeShellScript "yazi-wrapper" ''
          set -e

          multiple="$1"
          directory="$2"
          save="$3"
          path="$4"
          out="$5"

          exec ${pkgs.alacritty}/bin/alacritty --class file_chooser -e ${pkgs.coreutils}/bin/env YAZI_CONFIG_HOME=${config.home.homeDirectory}/.config/yazi ${pkgs.yazi}/bin/yazi --chooser-file="$out" "$path"
          ''}
        default_dir=/tmp
        open_mode=suggested
        save_mode=suggested
      '';
    };
  };
}
