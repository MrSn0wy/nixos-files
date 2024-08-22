# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgs-stable, pkgs-unstable, ... }:

{
## Settings
  # imports =
  #   [ # Include the results of the hardware scan.
  #     ./hardware-configuration.nix
  #   ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = [ "root" "snowy" ];
  };

  nixpkgs.config.allowUnfree = true; # Allow unfree packages

  swapDevices = [
    { device = "/swapfile"; size = 16384; } # 16 gb swap file
  ];


## Services
  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs-unstable.linuxPackages_latest;
    kernelParams = ["module_blacklist=nouveau" "nvidia_drm.fbdev=1"];
    kernel.sysctl = {"vm.swappiness" = 70;};

    loader = {
      systemd-boot.enable = true; # Use the systemd-boot EFI boot loader.
      systemd-boot.consoleMode = "max";
      systemd-boot.editor = true;
      efi.canTouchEfiVariables = true;
    };

    extraModprobeConfig = ''
    options snd-hda-intel power_save=0 power_save_controller=N
    '';
  };
  
  services = {

    xserver = {
        enable = true;

        displayManager = {
          lightdm.enable = false;
        };

        videoDrivers = ["nvidia"]; # Load nvidia driver for Xorg and Wayland

        excludePackages = with pkgs; [ xterm ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };


    displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
      sddm.theme = pkgs.lib.mkForce "snow";
      sddm.wayland.compositor = pkgs.lib.mkForce "kwin";
      defaultSession = "hyprland";
    };

    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };

    # cage.enable = true;
    # cage.user = "snowy";
    ntp.enable = true;
    udisks2.enable = true;
    flatpak.enable = true;
  };

  virtualisation = {
    # docker ={
    #    enable = true;
    #    rootless = {
    #      enable = true;
    #      setSocketVariable = true;
    #    };
    # };

    podman = {
        enable = true;
    };

    virtualbox = {
        host = {
            enable = true;
            enableExtensionPack = true;
        };
        guest = {
            enable = true;
            # draganddrop = true;
            clipboard = true;
        };
    };
  };


  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa
    gwenview
    okular
    kate
    khelpcenter
    #krdp
    kwrited
    konsole
    sddm
    dolphin
    ark
  ];


## Networking

  networking = {
    hostName = "SnowFlake"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    nameservers = ["1.1.1.1" "1.0.0.1" ]; # "2606:4700:4700::1111" "2606:4700:4700::1001"
  };

  time.timeZone = "Europe/Amsterdam"; # Set your time zone.

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_GB.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
  };

  # console = {
  #   font = "Lat2-Terminus32";
  #   #keyMap = "us"; # why does this not work??
  #   useXkbConfig = true; # use xkb.options in tty.
  # };


## Hardware

  hardware = {
    opengl.enable = true; # Enable OpenGL (old)
    # graphics = {
    #   enable = true; # Enable OpenGL (new)
    #   enable32Bit = true;
    # };

    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };


    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      powerManagement.enable = false;
      powerManagement.finegrained = false;

      open = false;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };


## User
  users = {
    groups.snowy = {};

    users = {
      snowy = { # Defining da Snowy
        isNormalUser = true;
        description = "Snowy";
        home = "/mnt/SnowData/snowy";
        shell = pkgs-stable.zsh;
        extraGroups = [ "wheel" "gamemode" "wireshark" "adbusers" "vboxusers" ];
      };
    };
  };

  # kinda silly, ngl
  system.activationScripts.script.text = ''
    cp /mnt/SnowData/snowy/Pictures/snowy /var/lib/AccountsService/icons/
  '';

## System Packages && Programs

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs-stable; [
    fastfetch
    neofetch
    nh
    gdu
    # nix-output-monitor
    htop
    alsa-utils
    noto-fonts
    pkgs.microcodeAmd
    terminus_font
    #sddm-chili-theme
    vulkan-tools
    xorg.xlsclients
    pkgs-unstable.winePackages.unstable
    # libsForQt5.konsole
    #wlr-randr

    libsForQt5.dolphin
    libsForQt5.ark
    # libsForQt5.konsole

    xwaylandvideobridge
    # kdePackages.dolphin
    # kdePackages.ark
    nixd
    tldr
    cage

    wineWowPackages.staging
    winetricks
    wineWowPackages.waylandFull
    # kdePackages.spectacle
  ];

  programs = {

    # haguichi.enable = true;

    firefox = {
      enable = true;
      package = pkgs-unstable.firefox-devedition-bin;
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };


    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

      gamescopeSession.enable = true;
    };

    gamescope = {
      enable = true;

    };


    wireshark = {
      enable = true;
      package = pkgs-stable.wireshark;
    };


    noisetorch = {
      enable = true;
      package = pkgs-unstable.noisetorch;
    };


    adb = {
      enable = true;
    };


    zsh = {
      enable = true;
    };


    gamemode = {
      enable = true; # enable gamemode :3

      settings = {
        general = {
          renice = 0;
        };

        # Currently bugged -.-
        # gpu = {
        #   apply_gpu_optimisations = "accept-responsibility";
        #   gpu_device = "2";
        #   nv_powermizer_mode = 1;
        #   nv_core_clock_mhz_offset = 200;
        #   nv_mem_clock_mhz_offset = 400;
        # };

        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started!'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode stopped!'";
        };
      };
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}