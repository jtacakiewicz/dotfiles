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
    programs = {
        firefox = {
            enable = true;
            package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
                extraPolicies = {
                    DisableTelemetry = true;
                    ExtensionSettings = {
                        "*".installation_mode = "blocked";
                        "uBlock0@raymondhill.net" = {
                            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                            installation_mode = "force_installed";
                        };
                        "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
                            install_url =
                                "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
                            installation_mode = "force_installed";
                        };
                    };

                    Preferences = { 
                        "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
                        "extensions.pocket.enabled" = lock-false;
                        "extensions.screenshots.disabled" = lock-true;
                    };
                };
            };

            profiles ={
                profile_0 = {           # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
                    id = 0;               # 0 is the default profile; see also option "isDefault"
                    name = "profile_0";   # name as listed in about:profiles
                    isDefault = true;     # can be omitted; true if profile ID is 0
                    settings = {          # specify profile-specific preferences here; check about:config for options
                        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
                        "browser.startup.homepage" = "https://nixos.org";
                        "browser.newtabpage.pinned" = [{
                            title = "NixOS";
                            url = "https://nixos.org";
                        }];
                    };
                };
                # profile_1 = {
                #   id = 1;
                #   name = "profile_1";
                #   isDefault = false;
                #   settings = {
                #     "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
                #     "browser.startup.homepage" = "https://ecosia.org";
                #   };
                # };
            };
        };
    };
}
