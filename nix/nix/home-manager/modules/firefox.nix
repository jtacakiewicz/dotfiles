{ config, pkgs, ... }:

let
    lock-false = {
        Value = false;
        Status = "locked";
    };
    lock-true = {
        Value = true;
        Status = "locked";
    };
in
    {
    xdg.enable = true;
    programs = {
        firefox = {
            package = pkgs.firefox;
            enable = true;
            configPath = "${config.xdg.configHome}/mozilla/firefox";
            policies = {
                DisableTelemetry = true;
                ExtensionSettings = {
                    "*".installation_mode = "blocked";
                    "uBlock0@raymondhill.net" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                        installation_mode = "force_installed";
                    };
                    "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
                        installation_mode = "force_installed";
                    };
                };

                Preferences = { 
                    "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
                    "extensions.pocket.enabled" = lock-false;
                    "extensions.screenshots.disabled" = lock-true;
                };
            };

            profiles = {
                default = {
                    id = 0;
                    name = "default";
                    isDefault = true;
                    settings = {
                        # "browser.startup.homepage" = "https://duckduckgo.com";
                        "browser.search.defaultenginename" = "ddg";
                        "browser.search.order.1" = "ddg";

                        "signon.rememberSignons" = false;
                        "widget.use-xdg-desktop-portal.file-picker" = 1;
                        "browser.aboutConfig.showWarning" = false;
                        "browser.compactmode.show" = true;
                        "browser.cache.memory.enable" = true;
                        "browser.cache.memory.capacity" = 1048576; # 1 GB memory cache max

                        "gfx.webrender.all" = true;
                        "media.hardware-video-decoding.enabled" = true;

                        "network.dns.disablePrefetch" = false;
                        "network.prefetch-next" = true;

                        "browser.download.alwaysOpenPanel" = true;

                        "widget.disable-workspace-management" = true;
                        "network.connectivity-service.UUID" = "";
                        "mousewheel.default.delta_multiplier_x" = 100;
                        "mousewheel.default.delta_multiplier_y" = 100;
                        "mousewheel.default.delta_multiplier_z" = 100;
                    };
                    search = {
                        force = true;
                        default = "ddg";
                        order = [ "ddg" "google" ];
                    };
                };
                kiosk = {
                    id = 1;
                    name = "kiosk";
                    isDefault = false;
                    settings = {
                        "browser.startup.homepage" = "https://duckduckgo.com";
                        "browser.startup.page" = 1; # Open the homepage on startup
                        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

                        "browser.sessionstore.resume_from_crash" = false;
                        "browser.sessionstore.max_resumed_crashes" = 0;

                        "browser.tabs.warnOnClose" = false;
                        "browser.sharedData.active" = false;
                        "signon.rememberSignons" = false;
                        "browser.shell.checkDefaultBrowser" = false;

                        "browser.aboutConfig.showWarning" = true;

                        "gfx.webrender.all" = true;
                        "media.hardware-video-decoding.enabled" = true;
                        "browser.cache.memory.enable" = true;
                        "browser.cache.memory.capacity" = 1048576;
                    };
                    userChrome = ''
                        @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

                        /* Optional: ensure the chrome folder exists and the stylesheet is loaded */
                        #navigator-toolbox, /* main toolbar container */
                        #TabsToolbar, /* tab bar */
                        #nav-bar, /* address bar and navigation controls */
                        #PlacesToolbar, /* bookmarks/search bar area if present */
                        #titlebar, /* title bar (the OS window title) */
                        #toolbar-menubar, /* menu bar (if visible) */
                        #bookmarksBarToolbar, /* bookmarks toolbar (if present) */
                        #Buttons, /* generic placeholder, might not exist depending on version */
                        #TabsToolbar, #nav-bar { display: none !important; }

                        /* If you want to keep a slim navigation panel (home/back/forward) visible, adjust selectively.
                        For a completely hidden chrome, keep the previous block and remove this one. */
                        // #back-button, #forward-button, #reload-button, #home-button, #urlbar, #searchbar { display: none !important; }

                        /* Fullscreen-like behavior: auto-hide the top chrome until mouse enters */
                        #top-controls { display: none !important; } /* older theme elements */
                        #titlebar { display: none !important; }

                        /* If you want to auto-hide the top bar but reveal on hover, use this (optional) */
                        #navigator-toolbox[closed-when-fullscreen="true"] { display: none !important; }
                        #navigator-toolbox:hover { display: -moz-box !important; }

                        /* Ensure content area uses full height when chrome is hidden */
                        #content, #main-journal { height: 100% !important; }

                        /* Optional: remove context menu top bar (in case any extra bars appear) */
                        #context-navigation { display: none !important; }
                    '';
                };
            };
        };
    };
}
