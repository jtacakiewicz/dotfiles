{ config, pkgs, lib, localDNSip, ... }:

{
    imports =
        [
            ./hardware-configuration.nix
            ./ly-login.nix
            ../shared/common.nix
        ];

    boot.loader.systemd-boot.enable = true;
    boot.kernelParams = [ 
        "nvme_core.default_ps_max_latency_us=0"
        "pcie_aspm=off"
        "nvme_core.hmb_for_ssd=0"
        "nvme_core.set_min_log_size=0"
        "video=DP-1:1920x1080@60"
        "video=HDMI-A-1:1920x1080@60"
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "ogisui"; 
    networking.nameservers = [ localDNSip ];
    networking.networkmanager = {
        enable = true;
        dns = "none";
        insertNameservers = [ localDNSip ];
    };

    hardware.graphics.enable = true;
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = true;
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
            General = {
                AutoEnable = true; 
                FastConnectable = true;
            };
        };
    };

    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;
    services.logind.enable = true;

    services.xserver = {
	enable = false;
	videoDrivers = [ "nvidia" ];
        xkb = {
            layout = "us";
            variant = "";
            options = "ctrl:nocaps";
        };
    };
    services.dbus = {
        enable = true;
        implementation = "broker";
    };
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [ "--unsupported-gpu" ];
    };

    environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1"; # Prevents cursor invisibility on Nvidia
        NIXOS_OZONE_WL = "1";          # Hints Electron apps (like VSCode/Chromium) to run natively on Wayland
        XDG_CURRENT_DESKTOP = "sway";
        XDG_SESSION_TYPE = "wayland";
    };

    services.displayManager.defaultSession = "sway";

    services.displayManager.gdm.enable = false;
    services.desktopManager.gnome.enable = false;

    services.printing.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    services.blueman.enable = true;

    users.users.jamjan = {
        isNormalUser = true;
        description = "jamjan";
        extraGroups = [ "networkmanager" "wheel" "seat" ];
	shell = pkgs.zsh;
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        neovim
        wget
	zsh
        git
        steam
    ];
    programs.steam.enable = true;
    programs.dconf.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?

}
